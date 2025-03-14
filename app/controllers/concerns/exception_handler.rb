module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      notify_error(e, airbrake_notify: true)
      render_error(500, e.message)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      notify_error(e)
      message = (e.message.present? && e.message != 'ActiveRecord::RecordNotFound') ? e.message : I18n.t('errors.record_not_found')
      render_error(404, message)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      notify_error(e)
      message = (e.message.present? && e.message != 'ActiveRecord::RecordInvalid') ? e.message : I18n.t('errors.record_invalid')
      render_error(422, message)
    end

    rescue_from ActionController::ParameterMissing do |e|
      notify_error(e)
      render_error(404, e.message)
    end

    rescue_from JSON::ParserError do |e|
      notify_error(e)
      render_error(404, I18n.t('errors.record_invalid'))
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      notify_error(e)
      message = (e.message.present? && e.message != 'ActiveRecord::RecordNotUnique') ? e.message : I18n.t('errors.record_not_unique')
      render_error(404, message)
    end

    private

    def notify_error(error, airbrake_notify: false)
      airbrake_notify(error) if airbrake_notify
      raise_error(error)
    end

    def raise_error(error)
      if Rails.env.test? || Rails.env.development?
        raise error
      end
    end

    def airbrake_notify(error)
      if Rails.env.production? || Rails.env.staging?
        Airbrake.notify(error)
      end
    end
  end
end
