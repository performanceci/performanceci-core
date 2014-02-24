class BuildEndpoint < ActiveRecord::Base
  belongs_to :repository
  belongs_to :endpoint
  belongs_to :build

  STATUSES = %w(success failed warn error)

  before_create :set_status

  def set_status
    if status != :error
      if average_response
        if endpoint.max_response_time && average_response > endpoint.max_response_time
          self.status = :failed
        elsif endpoint.warn_response_time && average_response > endpoint.warn_response_time
          self.status = :warn
        else
          self.status = :success
        end
      else
        self.status = :error
      end
    end
  end
end
