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

ActiveRecord::Schema.define(version: 20200227101728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "educations", force: :cascade do |t|
    t.bigint "profile_id"
    t.bigint "firm_id"
    t.string "degree"
    t.date "join_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_educations_on_firm_id"
    t.index ["profile_id"], name: "index_educations_on_profile_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.bigint "profile_id"
    t.bigint "firm_id"
    t.string "position"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firm_id"], name: "index_experiences_on_firm_id"
    t.index ["profile_id"], name: "index_experiences_on_profile_id"
  end

  create_table "firms", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "profile_picture"
    t.string "home_picture"
    t.bigint "followers"
    t.bigint "firmtype_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["firmtype_id"], name: "index_firms_on_firmtype_id"
  end

  create_table "firmtypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "github_profiles", force: :cascade do |t|
    t.text "access_token"
    t.text "profile_url"
    t.string "github_profile_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_github_profiles_on_user_id"
  end

  create_table "linkedin_profiles", force: :cascade do |t|
    t.text "access_token"
    t.datetime "expire_in"
    t.text "profile_url"
    t.string "linkedin_profile_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed_profiles", default: false
    t.index ["user_id"], name: "index_linkedin_profiles_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "fullname"
    t.datetime "dateofbirth"
    t.string "gender"
    t.string "phone"
    t.string "address"
    t.string "nationality"
    t.string "degree"
    t.text "lifemotto"
    t.string "profile_picture"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
    t.string "home_picture"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "profile_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_sections_on_profile_id"
  end

  create_table "specialities", force: :cascade do |t|
    t.bigint "profile_id"
    t.string "name"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_specialities_on_profile_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.text "status"
    t.string "photo"
    t.integer "status_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "sub_sections", force: :cascade do |t|
    t.bigint "section_id"
    t.string "title"
    t.string "data"
    t.string "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_sub_sections_on_section_id"
  end

  create_table "things", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.bigint "thingtype_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_things_on_user_id"
  end

  create_table "thingtypes", force: :cascade do |t|
    t.string "typename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "educations", "firms"
  add_foreign_key "educations", "profiles"
  add_foreign_key "experiences", "firms"
  add_foreign_key "experiences", "profiles"
  add_foreign_key "firms", "firmtypes"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend"
  add_foreign_key "github_profiles", "users"
  add_foreign_key "linkedin_profiles", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "sections", "profiles"
  add_foreign_key "specialities", "profiles"
  add_foreign_key "statuses", "users"
  add_foreign_key "sub_sections", "sections"
  add_foreign_key "things", "thingtypes"
  add_foreign_key "things", "users"
end
