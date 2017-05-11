class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :owner_id
      t.string :owner_type
      t.attachment :image
      t.boolean :deleted, :null => false , :default => false
      t.timestamps
    end
  end
end
