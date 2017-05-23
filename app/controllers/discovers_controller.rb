class DiscoversController < BaseController

  def index
    user_conn = Post.with_user_connect current_user_info
    @posts = Post.show_post.where(user_conn).order(:weight => :desc).page(params[:page]).per(PER_PAGE18)
  end
end
