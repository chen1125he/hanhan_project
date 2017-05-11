class PostsController < BaseController

  before_action :get_post, :only => [:show]

  def index
    @posts = Post.includes(:post_picture).all
  end

  def show
    @comments = Comment.show_comment @post.id, params
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(get_params)
    Post.transaction do
      @post.user = current_user
      if save_or_update_picture && @post.save
        flash[:notice] = I18n.t('messages.release_success')
        redirect_to posts_path
      else
        flash[:error] = I18n.t('messages.release_failed')
        render 'new'
        raise ActiveRecord::Rollback
      end
    end
  end

  private
  def get_params
    strip params.fetch(:post).permit(:title, :content, :detail, :plate_id)
  end

  def save_or_update_picture
    if params[:post].present? && params[:post][:image].present?
      picture = @post.post_picture
      if picture.blank?
        picture = PostPicture.new
        picture.owner = @post
      end
      picture.image = params[:post][:image]
      picture.save
    end
    true
  end

  def get_post
    @post = Post.show_post.where(:id => params[:id]).first
    unless @post.present?
      respond_to do |format|
        format.js{}
        format.html{flash[:notice] = I18n.t'messages.no_data';redirect_to posts_path}
      end
    end
  end
end
