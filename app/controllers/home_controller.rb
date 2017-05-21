class HomeController < BaseController


  def index
    @posts = Post.show_post.page(params[:page]).per(PER_PAGE12)
    @notice = Notice.display_notice
    @hot_plates = Plate.hot_plate
  end


  def search
    conn = Post.get_conn params
    @posts = Post.show_post.where(conn).page(params[:page]).per(PER_PAGE12)
    p @posts
    @plate = Plate.show_plates.where(:id => params[:plate_id]).first
  end
end
