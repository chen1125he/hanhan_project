class HomeController < BaseController


  def index
    @notice = Notice.display_notice
  end
end
