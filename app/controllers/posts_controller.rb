class PostsController < BaseController

  before_action :get_post, :only => [:show, :say_good, :cancel_say_good]

  def index
    @posts = Post.includes(:post_pictures).all
  end

  def show
    @comments = Comment.show_comment @post.id, params
    @post.update_read_num request.remote_ip, current_user
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

  # 更新点赞数,点赞需要用户登录
  def say_good
    @good_flag = @post.update_good_num request.remote_ip, current_user
  end

  def cancel_say_good
    @cancel_good_flag = @post.update_good_num request.remote_ip, current_user, true
  end

  private
  def get_params
    strip params.fetch(:post).permit(:title, :content, :detail, :plate_id)
  end

  def save_or_update_picture
    if params[:images].present?
      pictures = @post.post_pictures
      params[:images].each do |image|
        picture = PostPicture.new
        picture.owner = @post
        picture.image = image
        pictures << picture
      end
    end
    true
  end

  def get_post
    @post = Post.show_post.where(:id => params[:id]).first
    unless @post.present?
      respond_to do |format|
        flash[:notice] = I18n.t'messages.no_data'
        format.js{render :js => "location.href='#{posts_path}'"}
        format.html{redirect_to posts_path}
      end
    end
  end
end
