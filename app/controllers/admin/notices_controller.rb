class Admin::NoticesController < ApplicationController

  before_action :set_notice, :only => [:edit, :update, :destroy]

  def index
    @notices = Notice.all.page(params[:page]).per(PER_PAGE).order(:updated_at => :desc)
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

  def edit

  end

  def update
    split_date
    if @notice.update(get_params)
      flash[:notice] = I18n.t('messages.update_success')
      redirect_to admin_notices_path
    else
      flash[:error] = I18n.t('messages.update_faild')
      render 'edit'
    end
  end

  def destroy
    @notice.destroy
    flash[:notice] = I18n.t('messages.delete_success')
    redirect_to admin_notices_path
  end

  private
  def get_params
    strip params.fetch(:notice).permit(:title, :show_flag, :content)
  end

  def split_date
    @notice.show_from, @notice.show_to = params[:show_date].split(" - ") if params[:show_date].present?
  end

  def set_notice
    @notice = Notice.where(:id => params[:id]).first
    unless @notice.present?
      flash[:notice] = I18n.t('messages.no_data')
      redirect_to admin_notices_path
    end
  end
end
