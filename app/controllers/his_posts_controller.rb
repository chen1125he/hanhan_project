class HisPostsController < BaseController

  before_action :set_user
  layout 'his'
  def index
    params[:more] = "1"

    @his_posts = Post.includes(:post_pictures).show_post.where(:user_id => @user.try(:id)).page(params[:page]).per(PER_PAGE12)
  end

  private
  def set_user
    @user = UserInfo.where(:id => params[:user]).first.try(:user)
    unless @user.present?
      flash[:notice] = I18n.t('messages.user_not_exist');
      redirect_to home_path
    end
  end
end
