module Pagination
  extend ActiveSupport::Concern

  def pagination_headers(collection, item_name)
    headers['Content-Range'] = "#{item_name} #{collection.offset_value}-#{collection.offset_value + collection.limit_value - 1}/#{collection.total_count}"
    headers['Access-Control-Expose-Headers'] = 'Content-Range'
  end

  def pagination_headers_for_dropdown(item_name)
    headers['Content-Range'] = "#{item_name} 0-999/1000"
    headers['Access-Control-Expose-Headers'] = 'Content-Range'
  end

  def default_per_page
    10
  end

  def prepare_pagination_params
    if params[:range].present? && params[:range].is_a?(Array) && params[:range].length == 2
      beginning_offset = params[:range][0].to_i
      end_offset = params[:range][1].to_i
      per_page = end_offset - beginning_offset + 1
      params[:perPage] = per_page
      params[:page] = (beginning_offset / per_page) + 1
    end
  end
end