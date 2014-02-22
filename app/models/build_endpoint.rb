class BuildEndpoint < ActiveRecord::Base
  belongs_to :repository
  belongs_to :endpoint
  belongs_to :build
end
