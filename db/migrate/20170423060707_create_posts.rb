class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id
      t.integer :plate_id
      t.string :title
      t.text :content
      t.boolean :show_flag
      t.integer :read_num
      t.boolean :deleted, null:false, :default => false


      t.timestamps
    end
  end
end
