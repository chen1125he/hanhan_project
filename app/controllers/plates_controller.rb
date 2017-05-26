class PlatesController < BaseController

  before_action :set_plate, :only => [:cancel_care_plate, :care_plate]

  def index
    @plates = Plate.selectable_plates
  end

  def care_plate
    unless UserInfoPlate.where(user_info: current_user_info, plate: @plate).first.present?
      UserInfoPlate.new(:user_info_id => current_user_info.id, :plate_id => @plate.id).save(:validate => false)
    end
  end

  def cancel_care_plate
    UserInfoPlate.where(user_info: current_user_info, plate: @plate).first.try(:destroy)
  end

  def set_plate
    @plate = Plate.selectable_plates.where(:id => params[:plate_id]).first
    unless @plate.present?
      flash[:notice] = I18n.t("messages.no_data")
      respond_to do |format|
        format.html { redirect_to home_path}
        format.js { render :js => "window.location.reload();"}
      end
    end
  end
end
