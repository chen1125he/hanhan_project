class UsersController < BaseController

  layout 'my'

  def edit
    @user = current_user
  end
end
