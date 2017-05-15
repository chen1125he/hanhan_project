class Admin::NoticesController < ApplicationController


  def index
    @plates = Plate.where(:id => 10086111).page(params[:page]).per(PER_PAGE)
  end

  def new
    @notice = Notice.new
  end
end
