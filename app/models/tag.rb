class Tag < ApplicationRecord
  include Codenamable

  has_many :tag_attachables, dependent: :destroy, class_name: 'TagAttachable'
  has_many :taggables, through: :tag_attachables
  belongs_to :tag_category, class_name: 'TagCategory'

  class << self
    def searchable_attributes
      %i[name tag_category_id]
    end
  end
end
