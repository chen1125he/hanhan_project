class HomeController < BaseController


  def index
    @notice = Notice.display_notice
    @hot_plates = Plate.hot_plate
  end
end
