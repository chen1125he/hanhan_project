class AddDeletedToNotices < ActiveRecord::Migration[5.0]
  def change
    add_column :notices, :deleted, :boolean, :default => false
  end
end
