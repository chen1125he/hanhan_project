class CreatePostReadNums < ActiveRecord::Migration[5.0]
  def change
    create_table :post_read_nums, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :ip

      t.boolean :deleted, :default => false

      t.timestamps
    end
  end
end
