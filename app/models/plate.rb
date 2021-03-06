class Plate < ApplicationRecord


  has_many :user_info_plates, :dependent => :destroy
  has_many :user_infos, :through => :user_info_plates
  has_many :posts

  validates :name, :uniqueness => true, :presence => true

  SHOW_FLAG = {true => '显示', false => '不显示'}
  # 搜索出6个选出随机的3个用作热门话题
  SHOW_PLATE_NUM = 3
  SHOW_IN_NUM = 6


  # 前台可以显示出的plate
  def self.show_plates
    Plate.where(:show_flag => true).joins(:posts).where("posts.post_status in (?)", [1, 4]).group("posts.plate_id").order("count(posts.plate_id) desc")
  end

  # 前台可以使用的plate
  def self.selectable_plates
    Plate.where(:show_flag => true)
  end

  # 搜索出6个帖子最多的板块，选出随机的3个用作热门话题
  def self.hot_plate
    hot_plates = Plate.where(:show_flag => true).joins(:posts).where("posts.post_status in (?)", [1, 4]).group("posts.plate_id").order("count(posts.plate_id) desc").limit(SHOW_IN_NUM)
    hot_plates.sample SHOW_PLATE_NUM
  end

  # 判断是否被当前用户关注了
  def be_cared_by? user_info
    UserInfoPlate.where(:user_info_id => user_info.try(:id), :plate_id => self.id).present?
  end
end
