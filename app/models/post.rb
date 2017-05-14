class Post < ApplicationRecord

  has_many :post_pictures,:dependent => :destroy, :as => :owner
  has_many :comments
  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 100}
  validates :title, :presence => true
  validates :plate_id, :presence => true


  def self.show_post
    where(:show_flag => true, :user_deleted_flag => false).order('posts.updated_at desc')
  end
end
