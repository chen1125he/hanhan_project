class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content
      t.boolean :show_flag, :default => true
      t.boolean :deleted, :default => true

      t.timestamps
    end
  end
end
