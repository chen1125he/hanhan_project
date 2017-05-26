class Admin::UsersController < ApplicationController

  before_action :set_user, :only => [:edit, :update]

  def index
    @users = User.all.page(params[:page]).per(PER_PAGE)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_params)
    @user.role_type = 'Admin'
    pp @user.save(:validate => false)
    pp @user.errors
  end

  def edit
    @user_info = @user.get_user_info
    @plates = Plate.all
  end

  def update
    unless @user.is_admin?
      @user.update_attribute(:login_permit, params[:login_permit])
    end
    flash[:notice] = I18n.t("messages.update_success")
    redirect_to admin_users_path
  end

  private
  def get_params
    params.fetch(:user).permit(:login, :password, :password_confirmation)
  end

  def set_user
    @user = User.where(:id => params[:id]).first
    unless @user.present?
      flash[:error] = I18n.t("messages.no_data")
      redirect_to admin_users_path
    end
  end
end
