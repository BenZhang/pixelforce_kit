FactoryBot.define do
  factory :tag_attachable, class: 'TagAttachable' do
    association :taggable, factory: :app_version
    association :tag
  end
end
