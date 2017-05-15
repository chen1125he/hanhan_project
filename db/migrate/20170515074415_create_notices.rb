class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :title
      t.text :content
      t.date :show_from, :default => '1970/01/01'
      t.date :show_to, :default => '2099/01/01'
      t.boolean :show_flag, :default => true
      t.timestamps
    end
  end
end
