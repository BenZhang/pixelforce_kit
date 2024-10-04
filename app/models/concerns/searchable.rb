module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(params = {}, search_order: { id: :desc }, scope: nil, &custom_filter_block)
      params = {} if params.nil?
      validate_search_params(params)
      validate_search_order(search_order)
      results = scope ||= all

      results = apply_keyword_search(results, params[:keyword]) if params[:keyword].present?
      results = apply_attribute_filters(results, params)
      results = apply_custom_filters(results, params, &custom_filter_block)
      results = none if results.nil?
      apply_ordering(results, search_order)
    end

    private

    def default_attributes
      %i[id created_at updated_at]
    end

    def validate_search_params(params)
      valid_keys = searchable_attributes + %i[keyword order] + default_attributes
      invalid_keys = params.keys.map(&:to_sym) - valid_keys
      if invalid_keys.any?
        raise ArgumentError, "Invalid search parameters: #{invalid_keys.join(', ')}, check searchable_attributes"
      end
    end

    def validate_search_order(search_order)
      valid_order_keys = searchable_orders
      invalid_keys = search_order.keys.map(&:to_sym) - valid_order_keys

      if invalid_keys.any?
        raise ArgumentError, "Invalid order: #{invalid_keys.join(', ')}, check searchable_orders"
      end
    end

    def apply_keyword_search(results, keyword)
      keyword = ["%#{keyword}%"] if keyword.is_a?(String)
      keyword_fields = searchable_keyword_fields

      if keyword_fields.any?
        conditions = keyword_fields.map { |field| "#{field} ILIKE ANY ( array[:keyword] )" }.join(' OR ')
        results.where(conditions, keyword:)
      else
        results
      end
    end

    def apply_attribute_filters(results, params)
      (searchable_attributes + default_attributes).each do |attr|
        value = params[attr] || params[attr.to_s]
        next if value.blank?

        results = if value.is_a?(Array)
                    results.where(attr => value.map { |value| sanitize_sql_like(value) })
                  else
                    results.where(attr => value)
                  end
      end
      results
    end

    def apply_custom_filters(results, params)
      if block_given?
        yield(results, params)
      else
        results
      end
    end

    def apply_ordering(results, search_order)
      if search_order.present?
        results.order(search_order)
      else
        results.order(id: :desc)
      end
    end

    def searchable_attributes
      # Override this method in the including class to specify which attributes are searchable
      column_names.map(&:to_sym) & %i[name code_name id user_id transaction_id payment_subscription_id]
    end

    def searchable_orders
      %i[id created_at updated_at]
    end

    def searchable_keyword_fields
      # Override this method in the including class to specify which fields should be searched for keywords
      column_names.map(&:to_sym) & %i[name code_name id user_id transaction_id payment_subscription_id]
    end
  end
end
