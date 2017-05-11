class CreatePlates < ActiveRecord::Migration[5.0]
  def change
    create_table :plates, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.text :info
      t.boolean :show_flag, :null => false, :default => true
      t.boolean :deleted, :null => false, :default => false

      t.timestamps
    end
  end
end
