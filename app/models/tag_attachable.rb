class TagAttachable < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :tag, class_name: 'Tag'

  validates :tag_id, presence: true
end
