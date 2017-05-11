class DeletedError < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :deleted

    add_column :comments, :deleted, :boolean, :default => false
  end
end
