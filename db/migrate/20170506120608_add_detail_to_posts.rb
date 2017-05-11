class AddDetailToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :detail, :text
  end
end
