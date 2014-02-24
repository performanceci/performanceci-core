class BuildEndpoint < ActiveRecord::Base
  belongs_to :repository
  belongs_to :endpoint
  belongs_to :build

  STATUSES = %w(success failed warn error)

  before_create :set_status

  def set_status
    if status != :error
      if response_time
        if endpoint.max_response_time && response_time > endpoint.max_response_time
          self.status = :failed
        elsif endpoint.target_response_time && response_time > endpoint.target_response_time
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
