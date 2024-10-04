module SearchParamsParser
  extend ActiveSupport::Concern

  def get_search_params
    return @get_search_params if defined?(@get_search_params)

    @get_search_params = search_params(search_filter_params)
  end

  def search_filter_params
    return {} if params[:filter].blank?

    @search_filter_params ||= additional_search_filter_params
    @search_filter_params
  end

  def additional_search_filter_params
    params.require(:filter).permit!
  end

  def search_params(extra_params = {})
    id = keywords&.first&.delete('%')&.to_i
    @search_params = if id && !id.zero?
                       extra_params.delete('keyword')
                       {
                         id: id
                       }
                     else
                       {
                         keyword: keywords
                       }
                     end
    @search_params.merge!(extra_params)
  end
end
