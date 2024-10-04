class TagCategory < ApplicationRecord
  include Codenamable

  has_many :tags, dependent: :destroy, class_name: 'Tag'
end
