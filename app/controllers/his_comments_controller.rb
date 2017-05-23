class HisCommentsController < BaseController

  before_action :set_user
  layout 'his'

  def index
    @his_comments = Comment.show_my_comment @user.get_user_info.id, params
  end

  private
  def set_user
    @user = UserInfo.where(:id => params[:user]).first.try(:user)
    unless @user.present?
      flash[:notice] = I18n.t('messages.user_not_exist');
      redirect_to home_path
    end
  end
end
