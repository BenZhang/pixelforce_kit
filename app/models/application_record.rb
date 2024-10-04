class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Searchable
  include Taggable

  class << self
    def attach_user_id_to_admin_activity?
      column_names.include?('user_id') || name == 'User'
    end
  end
end
