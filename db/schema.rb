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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110505194344) do

  create_table "affiliations", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "affiliations_answer_sets", :id => false, :force => true do |t|
    t.integer "affiliation_id", :null => false
    t.integer "answer_set_id",  :null => false
  end

  create_table "affiliations_users", :id => false, :force => true do |t|
    t.integer "affiliation_id", :null => false
    t.integer "user_id",        :null => false
  end

  create_table "answer_sets", :force => true do |t|
    t.integer "survey_id",              :null => false
    t.integer "primary_affiliation_id", :null => false
  end

  create_table "editors_surveys", :id => false, :force => true do |t|
    t.integer "survey_id", :null => false
    t.integer "user_id",   :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "dn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "user_id",  :null => false
  end

  create_table "multiple_choice_answers", :force => true do |t|
    t.integer "multiple_choice_question_id", :null => false
    t.integer "multiple_choice_option_id",   :null => false
    t.integer "answer_set_id",               :null => false
  end

  create_table "multiple_choice_options", :force => true do |t|
    t.integer  "multiple_choice_question_id", :null => false
    t.integer  "position"
    t.string   "title",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_id",                     :null => false
    t.integer  "position"
    t.string   "title",                         :null => false
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.boolean  "required",   :default => false, :null => false
  end

  add_index "questions", ["ancestry"], :name => "index_questions_on_ancestry"

  create_table "submissions", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "survey_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "description",                   :null => false
    t.datetime "start",                         :null => false
    t.datetime "end",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "all_answers", :default => true, :null => false
    t.integer  "owner_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                              :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                     :null => false
    t.string   "single_access_token",                   :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",            :default => 0, :null => false
    t.integer  "failed_login_count",     :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "employee_number",                       :null => false
    t.integer  "primary_affiliation_id",                :null => false
    t.datetime "ldap_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
