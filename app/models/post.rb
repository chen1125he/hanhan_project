class Post < ApplicationRecord

  has_one :post_picture,:dependent => :destroy, :as => :owner
  has_many :comments
  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 100}
  validates :title, :presence => true
  validates :plate_id, :presence => true


  def self.show_post
    self.where(:show_flag => true)
  end
end
