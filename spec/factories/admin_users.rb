FactoryBot.define do
  factory :admin_user do
    first_name { 'John' }
    last_name { 'Doe' }
    sequence(:email) { |n| "username+#{n}@example.com" }
    password { 'Password123!' }
    provider { 'email' }
    allow_password_change { false }
  end
end
