class AddFloorNumToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :floor_num, :integer
  end
end
