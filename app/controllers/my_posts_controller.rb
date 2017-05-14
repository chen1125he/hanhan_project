class MyPostsController < BaseController

  layout 'my'
  before_action :set_post, :only => [:destroy]
  def index
    per_page = params[:more] == '1' ? PER_PAGE12 : PER_PAGE3
    @my_posts = Post.includes(:post_pictures).show_post.where(:user_id => current_user.try(:id)).page(params[:page]).per(per_page)
  end

  def destroy
    @my_post.update_attribute(:user_deleted_flag, true)
    flash[:notice] = I18n.t('messages.delete_success')
    redirect_to :action => :index
  end

  private
  def set_post
    @my_post = Post.show_post.where(:user_id => current_user.try(:id)).first
    unless @my_post.present?
      flash[:error] = I18n.t('messages.no_data')
      redirect_to :action => :index
    end
  end
end
