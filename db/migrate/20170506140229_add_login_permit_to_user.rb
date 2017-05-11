class AddLoginPermitToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :login_permit, :boolean, :default => true
  end
end
