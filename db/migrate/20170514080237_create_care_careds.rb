class CreateCareCareds < ActiveRecord::Migration[5.0]
  def change
    create_table :care_careds, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :care_id
      t.integer :cared_id

      t.boolean :deleted, :default => false
      t.timestamps
    end
  end
end
