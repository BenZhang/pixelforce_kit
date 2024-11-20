module AccountDeletable
  extend ActiveSupport::Concern

  included do
    def soft_delete!
      ActiveRecord::Base.transaction do
        # raise error if user has any active subscription
        if try(:payment_subscriptions)&.active&.exists?
          raise StandardError, I18n.t('errors.user_deletion_error')
        end

        user_devices.destroy_all
        omniauths.destroy_all
        update_columns(
          deleted_at:           Time.zone.now,
          tokens:               nil,
          email:                nil,
          uid:                  nil,
          encrypted_password:   '',
          first_name:           nil,
          last_name:            nil,
          email_before_deleted: email,
          uid_before_deleted:   uid
        )
      end
    end
  end
end