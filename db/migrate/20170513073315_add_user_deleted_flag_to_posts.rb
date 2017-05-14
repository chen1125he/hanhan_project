class AddUserDeletedFlagToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :user_deleted_flag, :boolean, :default => false
  end
end
