class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    if @cloudfront_headers.present?
      data[:country] = @cloudfront_headers[:cloudfront_viewer_country_name]
      data[:region] = @cloudfront_headers[:cloudfront_viewer_country_region_name]
      data[:city] = @cloudfront_headers[:cloudfront_viewer_city]
    end
    super(data)
  end

  def track_event(data)
    params = data[:properties][:params].deep_dup
    sanitized_params = remove_password_params(params)
    data[:properties][:method] = request.method
    data[:properties][:params] = sanitized_params
    data[:user_type] = controller.try('current_user')&.class&.name || controller.try('current_admin_user')&.class&.name
    data[:user_id] = controller.current_admin_user.id if controller.try('current_admin_user').present?
    data[:admin_action_on_user_id] = controller.admin_action_on_user_id if controller.try('admin_action_on_user_id').present? 
    data[:cloudfront_headers] = @cloudfront_headers if @cloudfront_headers.present?
    super(data)
  end
  
  private

  def remove_password_params(params)
    case params
    when Hash
      params.each_with_object({}) do |(key, value), result|
        if key.to_s == 'controller' || key.to_s == 'action'
          result[key] = remove_password_params(value)
        elsif !(key.to_s.downcase.include?('password') || value.to_s.downcase.include?('password'))
          result[key] = remove_password_params(value)
        end
      end
    when Array
      params.map { |item| remove_password_params(item) }
    else
      params
    end
  end
end

# set to true for JavaScript tracking
Ahoy.api = true
Ahoy.track_bots = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false