class AddUserInfoIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :user_info_id, :integer

    Post.includes(:user => :user_info).all.each do |post|
      post.update_attribute(:user_info_id, post.try(:user).try(:get_user_info).try(:id))
    end
  end
end
