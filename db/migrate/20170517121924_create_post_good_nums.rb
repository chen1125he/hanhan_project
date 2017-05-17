class CreatePostGoodNums < ActiveRecord::Migration[5.0]
  def change
    create_table :post_good_nums, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
    t.integer :post_id
    t.integer :user_id
    t.string :ip

    t.boolean :deleted, :default => false

    t.timestamps
    end
    add_column :posts, :good_num, :integer, :default => 0
  end
end
