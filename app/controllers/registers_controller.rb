class RegistersController < BaseController

  def new
    @user = User.new
  end

  def create
    @user = User.new(get_params)
    @user.role_type = 'User'
    User.transaction do
      update_or_save_image

      @user_info = UserInfo.new
      @user_info.nick_name = @user.login
      @user_info.user = @user
      @user_info.save
      unless @user.save
        render 'new'
        pp @user.errors
        raise ActiveRecord::Rollback
      else
        flash[:notice] = I18n.t('messages.register_success')
        redirect_to home_path
      end
    end
  end

  def update_or_save_image
    if params[:user].present? && params[:user][:image].present?
      picture = @user.user_picture
      if picture.blank?
        picture = UserPicture.new
        picture.owner =  @user
      end
      picture.image = params[:user][:image]
      p picture.save
      p picture.errors
    end
  end

  def get_params
    params.fetch(:user).permit(:login, :password, :email, :password_confirmation)
  end
end
