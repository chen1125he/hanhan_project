class PostPicture < Picture
  has_attached_file :image, :style => {
      :show190 => '190x190>',
      :show500 => '500x500>'
  },
                    :url => '/attachment/post_pic/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/attachment/post_pic/:id/:style/:basename.:extension'


  validates_attachment :image, :presence => true,
                       :content_type => {:content_type => /\Aimage\/.*\Z/},
                       :size => {:less_than => 5.megabytes}
  do_not_validate_attachment_file_type :image
  belongs_to :post, :class_name => 'Post'
  belongs_to :owner, :polymorphic => true
  belongs_to :picture
end