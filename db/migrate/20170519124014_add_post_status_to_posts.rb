class AddPostStatusToPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :user_deleted_flag
    add_column :posts, :post_status, :integer, :default => 1
  end
end
