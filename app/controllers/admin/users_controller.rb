class Admin::UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_params)
    @user.role_type = 'Admin'
    pp @user.save(:validate => false)
    pp @user.errors
  end

  def get_params
    params.fetch(:user).permit(:login, :password, :password_confirmation)
  end
end
