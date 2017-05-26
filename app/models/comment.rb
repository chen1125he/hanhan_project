class Comment < ApplicationRecord

  belongs_to :post
  belongs_to :user
  belongs_to :user_info

  validates :content, :presence => true


  SHOW_FLAG = {
      true => "显示",
      false => "不显示"
  }

  def self.get_admin_conn params
    conn = [[]]

    if params[:title].to_s.strip.present?
      conn[0] << "posts.title like ?"
      conn << "%#{params[:title].to_s.strip}%"
    end

    if params[:login].to_s.strip.present?
      conn[0] << "users.login like ?"
      conn << "%#{params[:login].to_s.strip}%"
    end

    if params[:show_flag].to_s.strip.present?
      conn[0] << "comments.show_flag = ?"
      conn << (params[:show_flag].to_s.strip == 'true' ? 1:0)
    end

    if params[:content].to_s.strip.present?
      conn[0] << "comments.content like ?"
      conn << "%#{params[:content]}%"
    end

    conn[0] = conn[0].join(" and ")
    conn.flatten
  end

  # 获取下一层楼数
  def self.comment_next_floor post_id = nil
    comment = Comment.where(:post_id => post_id).order(:floor_num => :desc).limit(1).first
    if comment.try(:floor_num).present?
      comment.try(:floor_num) + 1
    else
      1
    end
  end

  def self.show_comment post_id = nil, params = nil
    Comment.includes(:user_info, :user).joins(:user_info, :user).where(:post_id => post_id).where('comments.floor_num is not null').order(:floor_num).page(params[:page]).per(PER)
  end

  def self.show_my_comment user_info_id, params
    Comment.includes(:post).joins(:post).where(:user_info_id => user_info_id).where('comments.floor_num is not null').order(:created_at => :desc).page(params[:page]).per(PER)
  end
end
