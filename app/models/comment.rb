class Comment < ApplicationRecord

  belongs_to :post
  belongs_to :user
  belongs_to :user_info

  validates :content, :presence => true

  def self.comment_next_floor post_id = nil
    comment = Comment.where(:post_id => post_id).order(:floor_num => :desc).limit(1).first
    if comment.try(:floor_num).present?
      comment.try(:floor_num) + 1
    else
      1
    end
  end

  def self.show_comment post_id = nil, params = nil
    Comment.includes(:user_info, :user).where(:post_id => post_id).where('comments.floor_num is not null').order(:floor_num).page(params[:page]).per(PER)
  end
end
