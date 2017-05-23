class CommentsController < BaseController

  before_action :set_post

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(strip params.fetch(:comment).permit(:content))
    @comment.post = @post
    @comment.user = current_user
    @comment.user_info = current_user.try(:user_info)
    @comment.floor_num = Comment.comment_next_floor @post.try(:id)
    @save_flag = false
    Comment.transaction do
      if @comment.save
        @save_flag = true
        @post.update_attribute(:comment_num, @post.comments.count)
        @post.update_weight
      else
        raise ActiveRecord::Rollback
      end
    end
    @comments = Comment.show_comment @post.id, params
  end

  private
  def set_post
    if !request.xhr?
      respond_to do |format|
        format.html{render :js => "window.location.href='#{posts_path}'"}
        return
      end
    end
    @post = Post.where(:id => params[:id]).first
    unless @post.present?
      respond_to do |format|
        format.js{flash[:notice] = I18n.t('messages.no_data');render :js => "window.location.href='#{posts_path}'"}
      end
    end
  end
end
