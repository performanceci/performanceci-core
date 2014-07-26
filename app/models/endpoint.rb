class Endpoint < ActiveRecord::Base
  belongs_to :repository
  has_many :build_endpoints
  belongs_to :build
end
