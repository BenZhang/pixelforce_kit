FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    sequence(:email) { |n| "username+#{n}@example.com" }
    provider { 'email' }
    global_notification { true }
    turned_off_notification_category_ids { [] }
  end
end
