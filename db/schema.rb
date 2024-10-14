ActiveRecord::Schema.define do  
  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "country"
    t.string  "first_name"
    t.string  "last_name"
    t.date    "dob"
    t.string  "timezone"
    t.datetime "last_visit_at"
    t.timestamps
  end

  create_table "admin_users", force: :cascade do |t|
    t.string :email
  end
end