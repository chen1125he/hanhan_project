class UserInfosController < BaseController

  layout 'my'

  def edit
    @plates = Plate.all
    @user_info = current_user.get_user_info
  end

  def update
    @user_info = current_user.get_user_info
    UserInfo.transaction do
      save_or_update_plate
      if @user_info.update(get_params) && save_or_update_picture
        flash[:notice] = I18n.t('messages.update_success')
        redirect_to :controller => 'user_infos', :action => 'edit'
      else
        pp @user_info.errors
        flash[:error] = I18n.t('messages.update_faild')
        render 'edit'
      end
    end
  end

  def destroy_user_image
    picture = current_user.get_user_info.user_info_picture
    if picture.present? && picture.id = params[:key].to_i
      picture.destroy
    end
  end

  private
  def get_params
    strip params.fetch(:user_info).permit(:nick_name, :sign, :sex, :job, :city, :birth)
  end

  # 更新用户关注的plates
  def save_or_update_plate
    params_plates = params[:plates]
    params_plates ||= []
    user_info_plates = @user_info.user_info_plates
    plate_ids = user_info_plates.pluck(:plate_id)
    params_plates.each do |plate_id|
      if plate_ids.include?(plate_id.to_i)
        plate_ids -= [plate_id.to_i]
        next
      end
      UserInfoPlate.new(:plate_id => plate_id, :user_info_id => @user_info.id).save(:validate => false)
    end

    UserInfoPlate.where("user_info_id = ? and plate_id in (?)", @user_info.id, plate_ids).each do |uip|
      uip.destroy
    end
  end

  def save_or_update_picture
    if params[:image].present?
      picture = @user_info.user_info_picture
      unless picture.present?
        picture = UserInfoPicture.new
        picture.owner = @user_info
      end
      picture.image = params[:image]
      picture.save
    else
      true
    end
  end

end
