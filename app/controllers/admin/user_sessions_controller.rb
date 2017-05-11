class Admin::UserSessionsController < ApplicationController

  layout 'admin_login_layout'

  skip_before_action :admin_login
  before_action :logined?, :only => [:destroy]
  before_action :logined, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    UserSession.with_scope(:find_options => {:conditions => "role_type = 'Admin'"}) do
      @user_session = UserSession.new(get_params)
    end
    if @user_session.save
      redirect_to admin_posts_path
    else
      flash[:error] = t 'messages.login_or_pass_error'
      render 'new'
    end
    p current_user_session
  end

  def destroy
    current_user_session.try(:destroy)
    flash[:notice] = t 'messages.log_out_success'
    redirect_to new_admin_user_session_path
  end

  private
  def get_params
    params.fetch(:user_session).permit(:login, :password)
  end

  def logined?
    unless current_user_session.present?
      redirect_to new_admin_user_session_path
    end
  end

  def logined
    if current_admin.present? && current_admin.try(:role_type) == 'Admin'
      flash[:notice] = I18n.t('messages.logined')
      redirect_to admin_posts_path
    end
  end
end
