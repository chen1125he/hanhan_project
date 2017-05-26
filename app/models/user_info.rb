class UserInfo < ApplicationRecord

  belongs_to :user
  has_many :user_info_plates, :dependent => :destroy
  has_many :plates, :through => :user_info_plates
  has_many :posts
  has_one :user_info_picture, :dependent => :destroy, :as => :owner



  # belongs_to :careder_, :polymorphic => true
  # has_many :user_infos, :through => :carers, :as => :careder_
  #
  # has_many :user_info

  validates :sign, :length => {:maximum => 20}

  JOB = {
      1 => '交互设计师',
      2 => '原画师',
      3 => '视觉设计师',
      4 => '平面设计师',
      5 => '建筑师',
      6 => '摄影师',
      7 => '画家',
      8 => '其它'
  }

  SEX = {
      1 => '男',
      0 => '女'
  }

  # 前台获取用户头像
  def get_user_image
    if self.user_info_picture.try(:image).try(:url).present?
      self.user_info_picture.try(:image).try(:url)
    else
      'user/timg.jpg'
    end
  end


  def cares
    cared_ids = CareCared.where(:care_id => self.id).pluck(:cared_id)
    UserInfo.user_info_show.where(:id => cared_ids)
  end

  def careds
    care_ids = CareCared.where(:cared_id => self.id).pluck(:care_id)
    UserInfo.user_info_show.where(:id => care_ids)
  end

  def has_cared user_id = nil
    CareCared.where(:care_id => self.id, :cared_id => user_id).present?
  end

  def self.user_info_show
    # TODO
    where("1=1")
  end
end
