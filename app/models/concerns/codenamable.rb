module Codenamable
  extend ActiveSupport::Concern

  included do
    before_create :set_code_name

    validates :name, presence: true
  end

  def set_code_name
    self.code_name = name.parameterize(separator: '_') if code_name.blank?
  end
end
