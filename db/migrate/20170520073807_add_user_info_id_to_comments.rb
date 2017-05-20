class AddUserInfoIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :user_info_id, :integer
  end
end
