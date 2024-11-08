class TagCategory < ApplicationRecord
  include Codenamable

  has_many :attached_tags, through: :tag_attachables, source: :tag
  has_many :tags, dependent: :destroy, class_name: 'Tag'
end
