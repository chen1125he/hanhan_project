class UsersController < BaseController

  layout 'my'

  def edit
    @user = current_user
  end

  def update
    User
    @user = current_user
    if @user.update(params.fetch(:user).permit(:pre_password, :password, :password_confirmation))
      flash[:notice] = I18n.t('messages.update_success')
      redirect_to my_posts_path
    else
      flash[:error] = I18n.t('messages.update_faild')
      render 'edit'
    end
  end
end
