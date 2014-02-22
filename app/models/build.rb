class Build < ActiveRecord::Base
  belongs_to :repository

  has_many :build_endpoints

  def self.from_payload(payload)
    user = User.find(payload[:user_id])
    repository = user.repositories.find_by_github_id(payload['repository']['id'])
    Build.new(
      payload: JSON.generate(payload.to_hash),
      before:  payload['before'],
      after: payload['after'],
      message: payload['message'],
      url: payload['url'],
      repository: repository)
  end

  def add_endpoint(url, headers, options = {})
    # Add other options to where clause to make them unique endpoints
    endpoint = repository.endpoints.where(url: url).first
    unless endpoint
      endpoint = Endpoint.create!({repository: repository, url: url,
        headers: JSON.generate(headers)}.merge(options))
    end
    endpoint
  end

end
