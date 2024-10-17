ActiveRecord::Schema.define do  
  create_table "users", force: :cascade do |t|
    t.string  :email
    t.string  :provider
    t.string  :country
    t.string  :first_name
    t.string  :last_name
    t.date    :dob
    t.string  :timezone
    t.datetime :last_visit_at
    t.boolean :global_notification
    t.bigint :turned_off_notification_category_ids, array: true
    t.timestamps
  end

  create_table "admin_users", force: :cascade do |t|
    t.string :email
    t.string :first_name
    t.string :last_name
    t.string :provider
    t.boolean :global_notification
    t.timestamps
  end
end