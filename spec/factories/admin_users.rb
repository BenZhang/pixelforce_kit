FactoryBot.define do
  factory :admin_user do
    first_name { 'John' }
    last_name { 'Doe' }
    sequence(:email) { |n| "username+#{n}@example.com" }
    provider { 'email' }
  end
end
