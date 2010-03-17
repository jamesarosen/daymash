# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091022230040) do

  create_table "archived_credentials", :id => false, :force => true do |t|
    t.integer  "id"
    t.string   "provider",   :limit => 64
    t.string   "identifier", :limit => 256
    t.integer  "user_id"
    t.datetime "deleted_at"
  end

  create_table "calendars", :force => true do |t|
    t.string   "uri",        :limit => 256, :null => false
    t.string   "title",      :limit => 256, :null => false
    t.integer  "user_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calendars", ["uri"], :name => "index_calendars_on_uri"
  add_index "calendars", ["user_id", "title"], :name => "index_calendars_on_user_id_and_title"
  add_index "calendars", ["user_id", "uri"], :name => "index_calendars_on_user_id_and_uri", :unique => true
  add_index "calendars", ["user_id"], :name => "index_calendars_on_user_id"

  create_table "credentials", :force => true do |t|
    t.string  "provider",   :limit => 64,  :null => false
    t.string  "identifier", :limit => 256, :null => false
    t.integer "user_id",                   :null => false
  end

  add_index "credentials", ["identifier", "provider", "user_id"], :name => "index_credentials_on_identifier_and_provider_and_user_id", :unique => true
  add_index "credentials", ["user_id"], :name => "index_credentials_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",             :limit => 256, :null => false
    t.string   "display_name",      :limit => 256
    t.string   "persistence_token", :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
