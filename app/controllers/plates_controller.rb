class PlatesController < BaseController

  def index
    @plates = Plate.show_plates
  end
end
