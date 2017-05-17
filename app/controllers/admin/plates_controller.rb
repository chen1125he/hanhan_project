class Admin::PlatesController < ApplicationController

  before_action :set_plate, :only => [:edit, :update, :destroy]

  def index
    @plates = Plate.all.page(params[:page]).per(PER_PAGE).order(:updated_at => :desc)
  end

  def new
    @plate = Plate.new
  end

  def create
    @plate = Plate.new(get_params)
    if @plate.save
      flash[:notice] = I18n.t('messages.save_success')
      redirect_to :action => :index
    else
      flash[:error] = I18n.t('messages.save_failed')
      render 'new'
    end
  end

  def edit

  end

  def update
    if @plate.update(get_params)
      flash[:notice] = I18n.t('messages.save_success')
      redirect_to :action => :index
    else
      flash[:notice] = I18n.t('messages.save_failed')
      render 'edit'
    end
  end

  def destroy
    @plate.destroy
    flash[:notice] = I18n.t('messages.delete_success')
    redirect_to :action => 'index'
  end

  private
  def get_params
    strip params.fetch(:plate).permit(:name, :show_flag, :info)
  end

  def set_plate
    @plate = Plate.where(:id => params[:id]).first
    unless @plate.present?
      flash[:notice] = t'messages.no_data'
      redirect_to :action => :index
    end
  end
end
