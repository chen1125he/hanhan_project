class Admin::NoticesController < ApplicationController


  def index
    @notices = Notice.all.page(params[:page]).per(PER_PAGE)
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(get_params)
    split_date
    if @notice.save
      flash[:notice] = I18n.t("messages.save_success")
      redirect_to admin_notices_path
    else
      flash[:error] = I18n.t("messages.save_failed")
      render 'new'
    end
  end

  private
  def get_params
    strip params.fetch(:notice).permit(:title, :show_flag, :content)
  end

  def split_date
    @notice.show_from, @notice.show_to = params[:show_date].split(" - ") if params[:show_date].present?
  end
end
