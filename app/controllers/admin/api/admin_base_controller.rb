require 'csv'

module Admin
  module Api
    class AdminBaseController < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      include ResponseHandler
      include RequestHeaderHandler
      include ExceptionHandler
      include Pagination

      layout false

      before_action :authenticate_admin_user!
      before_action :format_params
      before_action :prepare_pagination_params
      after_action :track_admin_request

      def authenticate_admin_user!
        authenticate_admin_api_admin_user!
      end

      def current_admin_user
        current_admin_api_admin_user
      end

      def log_target
        @log_target
      end

      def admin_action_on_user_id
        @admin_action_on_user_id = if log_target.present?
          if log_target.is_a?(User)
            log_target.id
          else
            log_target.user_id
          end
        end
      end

      def render_error(status, message, errors = nil, source: nil, meta: {})
        super(status, message, errors, source: source, meta: meta, admin_server_error: true)
      end

      private

      def track_admin_request
        unless params[:action] == 'index' || params[:action] == 'show'
          ahoy.track 'AdminLog', {
            params:   request.filtered_parameters,
            url:      request.original_url,
            response: response.status
          }
        end
      end

      def set_response_format
        if request.format.to_s != 'text/csv'
          request.format = :json
          self.content_type = 'application/json'
        end
      end      

      def keywords
        keyword = params[:filter].try(:[], :keyword)
        if keyword.present?
          @keywords = keyword.split(/,|  */).reject(&:blank?).map { |value| "%#{value.strip}%" }
        else
          []
        end
      end

      def export_resource_csv(resources, headers)
        resources = resources.except(:limit, :offset)
        table_name = resources.table_name
        csv_data = CSV.generate(headers: true) do |csv|
          csv << headers.map(&:titleize)
          resources.find_each do |resource|
            csv << headers.map { |header| resource.send(header.parameterize.to_sym) }
          end
        end
        send_data csv_data, filename: "#{table_name}-#{Date.today}.csv"
      end      

      def format_params
        if request.method_symbol == :get
          params[:filter] = ActionController::Parameters.new(JSON.parse(params[:filter])) if params[:filter].present? && params[:filter].is_a?(String)
          params[:range] = JSON.parse(params[:range]) if params[:range].present? && params[:range].is_a?(String)
        end
      end
    end
  end
end
