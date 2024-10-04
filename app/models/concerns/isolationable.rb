module Isolationable
  extend ActiveSupport::Concern

  def run_in_transaction(retry_times: 10, level: :repeatable_read, &block)
    if Rails.env.test?
      ActiveRecord::Base.transaction(&block)
    else
      ActiveRecord::Base.transaction isolation: level, &block
    end
  rescue ActiveRecord::SerializationFailure => e
    retry_times -= 1
    if retry_times.positive?
      retry
    else
      raise ActiveRecord::SerializationFailure
    end
  end
end
