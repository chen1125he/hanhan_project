class MyCaredsController < BaseController

  layout 'my'
  def index
    @careds = current_user_info.careds.page(params[:page]).per(PER_PAGE6)
  end
end
