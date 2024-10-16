module ResponseHandler
  extend ActiveSupport::Concern

  included do
    before_action :config_default_response_settings
    layout false
  end

  def config_default_response_settings
    set_response_format
  end

  def set_response_format
    if request.format.to_s != 'text/csv'
      request.format = :json
      self.content_type = 'application/json'
    end
  end

  def render_success
    render json: {}, status: :ok
  end

  def render_no_content
    render json: {}, status: :no_content
  end

  def render_error(status, message, errors = nil, source: nil, meta: {}, admin_server_error: false)
    response = {
      'status' => 'error',
      'source' => source,
      'errors' => {},
      'meta' => meta
    }
  
    if errors.is_a?(ActiveModel::Errors)
      errors.each do |error|
        attribute = error.attribute.to_s
        error_message = error.message
        response['errors'][attribute] ||= []
        response['errors'][attribute] << error_message
      end
    elsif errors.is_a?(Hash)
      response['errors'] = errors
    else
      response['errors'] = admin_server_error ? { 'root' => { 'serverError' => { message: message } } } : { 'server' => [message] }
    end
  
    render json: response, status: status
  end
end
