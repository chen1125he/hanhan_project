class AddWeightToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :weight, :float, :default => 0
  end
end
