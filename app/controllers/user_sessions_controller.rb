class UserSessionsController < BaseController
  before_action :logined?, :only => [:destroy]
  before_action :logined, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    UserSession.with_scope(:find_options => {:conditions => "role_type = 'User'"}) do
      @user_session = UserSession.new(get_params)
    end
    if @user_session.save
      unless current_user.try(:login_permit)
        flash[:error] = t 'messages.login_limited'
        current_user_session.try(:destroy)
        render 'new'
        return
      end
      flash[:notice] = I18n.t('messages.login_success')
      # redirect_to admin_posts_path
    else
      flash[:error] = t 'messages.login_or_pass_error'
      render 'new'
      return
    end
    redirect_to login_success_redirect
  end

  def destroy
    current_user_session.try(:destroy)
    flash[:notice] = t 'messages.log_out_success'
    redirect_to home_path
  end

  private
  def get_params
    strip params.fetch(:user_session).permit(:login, :password)
  end

  def logined?
    unless current_user_session.present?
      flash[:error] = I18n.t('messages.not_login')
      redirect_to new_user_session_path
    end
  end
  def logined
    if current_user.present? && current_user.try(:role_type) == 'User'
      flash[:notice] = I18n.t('messages.logined')
      redirect_to home_path
    end
  end
end
