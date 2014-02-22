class Build < ActiveRecord::Base
  belongs_to :repository

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

end
