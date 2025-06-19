FactoryBot.define do
  factory :tag_category, class: 'TagCategory' do
    sequence(:name) { |n| "tag_category_#{n}" }
    sequence(:code_name) { |n| "tag_category_#{n}" }
  end
end
