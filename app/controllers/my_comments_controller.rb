class MyCommentsController < BaseController

  layout 'my'
  def index
    @my_comments = Comment.show_my_comment current_user_info.id, params
  end
end
