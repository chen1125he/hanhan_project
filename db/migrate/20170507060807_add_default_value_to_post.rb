class AddDefaultValueToPost < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :read_num
    remove_column :posts, :show_flag

    add_column :posts, :read_num, :integer, :default => 0
    add_column :posts, :show_flag, :boolean, :default => true
  end
end
