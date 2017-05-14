# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170514080237) do

  create_table "care_careds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "care_id"
    t.integer  "cared_id"
    t.boolean  "deleted",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content",      limit: 65535
    t.boolean  "show_flag",                  default: true
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "floor_num"
    t.boolean  "deleted",                    default: false
    t.integer  "user_info_id"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "deleted",            default: false, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "plates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "info",       limit: 65535
    t.boolean  "show_flag",                default: true,  null: false
    t.boolean  "deleted",                  default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "plate_id"
    t.string   "title"
    t.text     "content",           limit: 65535
    t.boolean  "deleted",                         default: false, null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "detail",            limit: 65535
    t.integer  "read_num",                        default: 0
    t.boolean  "show_flag",                       default: true
    t.integer  "comment_num",                     default: 0
    t.boolean  "user_deleted_flag",               default: false
  end

  create_table "user_info_plates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_info_id"
    t.integer  "plate_id"
    t.boolean  "deleted",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "user_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "login",                             null: false
    t.string   "email"
    t.string   "crypted_password",                  null: false
    t.string   "password_salt",                     null: false
    t.string   "persistence_token",                 null: false
    t.string   "role_type",                         null: false
    t.integer  "login_count",        default: 0,    null: false
    t.integer  "failed_login_count", default: 0,    null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "login_permit",       default: true
  end

end
