class Repository < ActiveRecord::Base
  belongs_to :user

  has_many :endpoints
  has_many :builds

  STATUSES = %w(success failed warn error)

  def add_hook
    if existing_hook
      enable_hook(existing_hook)
    else
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
  end

  def existing_hook
    user.github_client.hooks(full_name).first
  end

  def enable_hook(hook)
    user.github_client.edit_hook(
      full_name,
      hook.id,
      'web',
      hook_url_config(user),
      hook_options)
  end

  def build_from_last_commit
    commits = user.github_client.commits(full_name)
    last_commit = commits[0]
    previous_commit = commits[1]
    previous_sha = previous_commit.sha
    last_sha = last_commit.sha
    compare = "https://github.com/akira/testhook/compare/#{previous_sha[0..11]}...#{last_sha[0..11]}"
    if last_commit && previous_commit
      build = Build.create!(
        payload: '{}',
        build_status: 'pending',
        before:  previous_sha,
        after: last_sha,
        message: last_commit.commit.message,
        compare: compare,
        url: "https://github.com/#{self.full_name}.git",
        repository: self)
      build.run_build
    end
  end

  def build_summary
    builds = self.builds.order('created_at desc').limit(20).includes(:build_endpoints)
    build_endpoints = builds.flat_map { |b| b.build_endpoints }
    grouped_endpoints = build_endpoints.group_by { |be| be.endpoint }

    grouped_endpoints = grouped_endpoints.map do |e,builds|
      result = []
      builds.sort_by { |b| b.created_at}.each_with_index do |b, i|
        result << { response_time: b.response_time, created_at: b.created_at, index: i,
          status: b.status || 'success', commit: b.build.after, compare:b.build.compare }
      end
      {endpoint: e, builds: result }
    end
  end

  def last_build
    builds.order("created_at DESC").first
  end

  private

  def hook_url_config(user)
    {
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
