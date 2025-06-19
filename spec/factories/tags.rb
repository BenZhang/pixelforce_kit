FactoryBot.define do
  factory :tag, class: 'Tag' do
    sequence(:name) { |n| "Tag #{n}" }
    sequence(:code_name) { |n| "tag_#{n}" }
    tag_category
  end
end
