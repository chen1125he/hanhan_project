class CreateUserInfoPlates < ActiveRecord::Migration[5.0]
  def change
    create_table :user_info_plates, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_info_id
      t.integer :plate_id

      t.boolean :deleted, :default => false
      t.timestamps
    end
  end
end
