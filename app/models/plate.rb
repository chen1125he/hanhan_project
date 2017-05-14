class Plate < ApplicationRecord


  has_many :user_info_plates, :dependent => :destroy
  has_many :user_infos, :through => :user_info_plates

  validates :name, :uniqueness => true, :presence => true

  SHOW_FLAG = {true => '显示', false => '不显示'}


  def self.show_plates
    Plate.where(:show_flag => true)
  end
end
