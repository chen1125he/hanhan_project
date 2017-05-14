class UserInfo < ApplicationRecord

  belongs_to :user
  has_many :user_info_plates, :dependent => :destroy
  has_many :plates, :through => :user_info_plates
  has_one :user_info_picture, :dependent => :destroy, :as => :owner

  has_many :carers, :foreign_key => 'care_id', :as => :carder
  has_many :careders, :foreign_key => 'cared_id', :as => :carer

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
end
