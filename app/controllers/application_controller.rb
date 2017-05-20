class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user_session, :current_user_info

  before_action :admin_login

  layout :layout_str

  PER_PAGE = 10
  PER_PAGE3 = 3
  PER_PAGE6 = 6
  PER_PAGE18 = 18
  PER_PAGE12 = 12

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
    if @current_user.try(:role_type) != "User"
      @current_user = nil
    else
      @current_user
    end
  end

  def current_user_info
    current_user.try(:get_user_info)
  end

  def current_admin
    @current_admin ||= current_user_session && current_user_session.record
    if @current_admin.try(:role_type) != "Admin"
      @current_admin = nil
    else
      @current_admin
    end
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
