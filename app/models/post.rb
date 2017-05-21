class Post < ApplicationRecord

  has_many :post_pictures,:dependent => :destroy, :as => :owner
  has_many :comments
  has_many :post_read_nums
  has_many :post_good_nums
  belongs_to :user
  belongs_to :plate

  validates :content, :presence => true, :length => {:maximum => 100}
  validates :title, :presence => true
  validates :plate_id, :presence => true

  POST_STATUS = {
      1 => '新建',
      2 => '用户删除',
      3 => '管理员屏蔽',
      4 => '管理员恢复'

  }

  def self.get_conn params = {}
    conn = [[]]
    if params[:plate_id].present?
      conn[0] << 'posts.plate_id = ?'
      conn << params[:plate_id]
    end

    if params[:key_word].present?
      conn[0] << "posts.title like ? or posts.content like ? or posts.detail like ?"
      conn << ["%#{params[:key_word].to_s.gsub(/^[　 ]+|[　 ]+$/, '')}%", "%#{params[:key_word].to_s.gsub(/^[　 ]+|[　 ]+$/, '')}%", "%#{params[:key_word].to_s.gsub(/^[　 ]+|[　 ]+$/, '')}%"]
    end

    conn[0] = conn[0].join(" and ")
    conn.flatten
  end

  def self.show_post
    # where(:show_flag => true, :user_deleted_flag => false).order('posts.updated_at desc')
    Post.joins(:plate).where('plates.show_flag = true').where(:post_status => [1, 4]).order('posts.updated_at desc')
  end

  def self.show_post_only
    where('plates.show_flag = true').where(:post_status => [1, 4]).order('posts.updated_at desc')
  end


  # 更新阅览数
  def update_read_num ip = "", user = nil
    conn = [[]]
    if ip.present?
      conn[0] << "post_read_nums.ip = ?"
      conn << ip
    end

    if user.present?
      conn[0] << "post_read_nums.user_id = ?"
      conn << user.id
    end
    conn[0] = conn[0].join(" and ")
    conn.flatten!
    read_num = PostReadNum.where(conn).first
    unless read_num.present?
      PostReadNum.transaction do
        read_num = PostReadNum.new(:ip => ip, :user_id => user.try(:id), :post_id => self.id)
        read_num.save(:validate => false)
        self.update_attribute(:read_num, self.read_num.to_i + 1)
      end
    end
  end

  # 更新点赞数,点赞需要用户登录
  def update_good_num ip = "", user = nil, cancel_flag = false
    conn = [[]]
    return false if ip.blank? || user.blank?

    conn[0] << "post_good_nums.ip = ?"
    conn << ip

    conn[0] << "post_good_nums.user_id = ?"
    conn << user.id

    conn[0] = conn[0].join(" and ")
    conn.flatten!
    read_num = PostGoodNum.where(conn).first
    unless read_num.present?
      PostGoodNum.transaction do
        read_num = PostGoodNum.new(:ip => ip, :user_id => user.try(:id), :post_id => self.id)
        read_num.save(:validate => false)
        self.update_attribute(:good_num, self.post_good_nums.count)
      end
    end
    # 取消点赞
    if cancel_flag && read_num.present?
      read_num.destroy
      self.update_attribute(:good_num, self.post_good_nums.count)
    end
    self.post_good_nums.count
  end
end
