class Repository < ActiveRecord::Base
  belongs_to :user
  before_create :add_hook

  has_many :endpoints
  has_many :builds

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

  def build_summary
    builds = self.builds.order('created_at desc').limit(20).includes(:build_endpoints)
    build_endpoints = builds.flat_map { |b| b.build_endpoints }
    grouped_endpoints = build_endpoints.group_by { |be| be.endpoint }
  end

  private

  def hook_url_config(user)
    {
      #TODO: Config
      #TODO: Generate random id instead of user id
      url: "#{ENV['WEBHOOK_URL']}/webhooks/#{user.id}",
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
