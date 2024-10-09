module Taggable
  extend ActiveSupport::Concern

  # tag_filter = {
  #   groups: [
  #     { category: 'workout' },
  #     { code_names: ['10-minutes', '20-minutes'] }
  #   ],
  #   logical_operator: 'and'
  # }

  included do
    has_many :tag_attachables, as: :taggable, dependent: :destroy, inverse_of: :taggable, class_name: 'TagAttachable'
    has_many :tags, through: :tag_attachables, source: :tag, class_name: 'Tag'

    accepts_nested_attributes_for :tag_attachables, allow_destroy: true

    scope :tagged_with, lambda { |tag_filter|
      groups = tag_filter[:groups]
      logical_operator = tag_filter[:logical_operator]&.downcase

      queries = groups.map do |group|
        if group[:code_names]
          subquery = joins(:tags).where(tags: { code_name: group[:code_names] })
                                 .group("#{table_name}.id")
                                 .having('COUNT(DISTINCT tags.id) = ?', group[:code_names].size)
        elsif group[:tag_category_id]
          subquery = joins(:tags).where(tags: { tag_category_id: group[:tag_category_id] })
                                 .group("#{table_name}.id")
        else
          next
        end

        subquery
      end.compact

      if queries.empty?
        all
      else
        if logical_operator == 'or'
          combined_query = queries.map(&:to_sql).join(' UNION ')
          combined_query = from("(#{combined_query}) AS #{table_name}")
        else
          combined_query = queries.reduce do |combined, query|
            if combined.nil?
              query
            else
              combined.where(id: query.select(:id))
            end
          end
        end

        combined_query.distinct
      end
    }
  end
end
