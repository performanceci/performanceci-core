class Repository < ActiveRecord::Base
  belongs_to :user

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
    save
  end

  def build_summary
    builds = self.builds.order('created_at desc').limit(20).includes(:build_endpoints)
    build_endpoints = builds.flat_map { |b| b.build_endpoints }
    grouped_endpoints = build_endpoints.group_by { |be| be.endpoint }

    grouped_endpoints = grouped_endpoints.map do |e,builds|
      result = []
      builds.sort_by { |b| b.created_at}.each_with_index do |b, i|
        result << { response_time: b.response_time, created_at: b.created_at, index: i,
          commit: b.build.after, compare:b.build.compare }
      end
      {endpoint: e, builds: result }
    end
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
