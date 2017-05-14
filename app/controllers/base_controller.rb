class BaseController < ApplicationController
  layout 'user'

  after_action :record_path
  before_action :login_need_auth


  # 前台需要登录才能访问的action
  LOGIN_AUTH_ACTION = {
      :posts => [:new, :create, :edit, :update],
      :comments => [:new, :create],
      :my_posts => [:index],
      :user_infos => [:edit, :update, :destroy_user_image]
  }
  # 需要记录，并在登录后跳转的页面
  # RECORD_ACTION = {
  #     :posts => [:new, :edit]
  # }

  def login_need_auth


    if LOGIN_AUTH_ACTION.has_key?(params[:controller].try(:to_sym)) && LOGIN_AUTH_ACTION[params[:controller].try(:to_sym)].try(:include?, params[:action].try(:to_sym))
      unless is_user?
        respond_to do |format|
          flash[:error] = I18n.t('messages.not_login')
          format.js{render(:js => "window.location.href='#{new_user_session_path}'"); return}
          format.html{redirect_to new_user_session_path}
        end
      end
    end
  end

  private
  def is_user?
    current_user.try(:role_type) == 'User'
  end

  def record_path
    # 记录get访问，并且不是登录页面的get，用于登录成功跳转
    if request.get? && (params[:controller] =~ /user_session/) == nil
      session[:controller] = params[:controller]
      session[:action] = params[:action]
      session[:id] = params[:id]
    end
  end

  def login_success_redirect
    if session[:controller].present? && session[:action].present?
      session[:id].present? ? {:controller => session[:controller], :action => session[:action], :id => session[:id]} : {:controller => session[:controller], :action => session[:action]}
    else
      home_path
    end
  end
end