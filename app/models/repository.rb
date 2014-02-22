class Repository < ActiveRecord::Base
  belongs_to :user
  before_create :add_hook

  def add_hook
    #repo = user.github_client.repos.find { |r| r.name == name}
    hook = user.github_client.create_hook(
      full_name,
      'web',
      hook_url_config(user),
      hook_options
    )
    self.hook_id = hook.id
    hook.id.present?
  end

  private

  def hook_url_config(user)
    {
      #TODO: Config
      #TODO: Generate random id instead of user id
      url: "http://ee75d51.ngrok.com/webhooks/#{user.id}",
      content_type: 'json'
    }
  end

  def hook_options
    {
      events: ['pull_request', 'push'],
      active: true
    }
  end
end
