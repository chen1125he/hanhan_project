class MyCaresController < BaseController

  layout 'my'
  def index
    @cares = current_user_info.cares.page(params[:page]).per(PER_PAGE6)
    # render 'user_common/care_list'
  end
end
