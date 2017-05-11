class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user_session

  before_action :admin_login

  layout :layout_str

  PER_PAGE = 10

  private
  def admin_login
    if params[:controller] =~ /admin\// && (current_admin.blank? || current_admin.try(:role_type) != 'Admin')
      flash[:error] = t'messages.not_login'
      redirect_to new_admin_user_session_path
    end
  end
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
  end

  def current_admin
    @current_user ||= current_user_session && current_user_session.record
  end

  def layout_str
    if params[:controller] =~ /\Aadmin\//
      if params[:controller] =~ /user_session/
        'admin_login_layout'
      else
        'admin'
      end
    else
      'user'
    end
  end


  def strip param
    param.each do |key, val|
      next if val.blank? or val.class == ActionDispatch::Http::UploadedFile
      param[key] = val.to_s.gsub(/^[　 ]+|[　 ]+$/, '')
    end
    param
  end

end
