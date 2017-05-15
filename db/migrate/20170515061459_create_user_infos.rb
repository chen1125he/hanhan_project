class CreateUserInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :user_infos, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id"
      t.string   "nick_name"
      t.string   "sign"
      t.integer  "sex",        default: 1
      t.integer  "job"
      t.string   "city"
      t.date     "birth"
      t.integer  "cares_num",  default: 0
      t.integer  "cared_num",  default: 0
      t.boolean  "deleted",    default: false

      t.timestamps
    end
  end
end
