class UserInfoPicture <Picture
  has_attached_file :image, :style => {
      :show => '140x140>'
  },
                    :url => '/attachment/user_info_picture/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/attachment/user_info_picture/:id/:style/:basename.:extension'


  validates_attachment :image, :presence => true,
                       :content_type => {:content_type => /\Aimage\/.*\Z/},
                       :size => {:less_than => 5.megabytes}
  do_not_validate_attachment_file_type :image
  belongs_to :UserInfo, :class_name => 'UserInfo'
  belongs_to :owner, :polymorphic => true
  belongs_to :picture
end