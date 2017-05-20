class CareCaredsController < BaseController

  def create
    @save_flag = false
    @cared_user_info = UserInfo.where(:id => params[:cared_id]).first
    if @cared_user_info.present?
      return @save_flag = true if CareCared.where(:care_id => current_user.get_user_info.id, :cared_id => params[:cared_id]).present?
      CareCared.transaction do
        if CareCared.new(:care_id => current_user.get_user_info.try(:id), :cared_id => @cared_user_info.id).save
          @cared_user_info.update_attribute(:cared_num, @cared_user_info.careds.count)
          pp @cared_user_info.careds.count
          current_user.get_user_info.update_attribute(:cares_num, current_user.get_user_info.cares.count)
          @save_flag = true
        end
      end
    end
  end

  def destroy
    @ca = CareCared.where(:care_id => current_user.get_user_info.id, :cared_id => params[:id]).first
    @cared_user_info = UserInfo.where(:id => params[:id]).first
    if @ca.present?
      CareCared.transaction do
        @ca.destroy
        @cared_user_info.update_attribute(:cared_num, @cared_user_info.careds.count) if @cared_user_info.present?
        current_user.get_user_info.update_attribute(:cares_num, current_user.get_user_info.cares.count)
      end
    end
  end
end
