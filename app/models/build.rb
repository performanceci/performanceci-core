class Build < ActiveRecord::Base
  belongs_to :repository

  has_many :build_endpoints

  scope :ongoing, -> { where("build_status NOT IN(?)", %w(success failed warn error))}
  scope :newish, -> { where(["created_at > ?", 1.hour.ago])}

  BUILD_STATUSES = %w(pending building_container attacking_container success failed warn error)

  #TODO: Fill this out
  def provider
    :docker
  end

  def self.from_payload(payload)
    user = User.find(payload[:user_id])
    repository = user.repositories.find_by_github_id(payload['repository']['id'])
    Build.new(
      payload: JSON.generate(payload.to_hash),
      build_status: 'pending',
      before:  payload['before'],
      after: payload['after'],
      message: payload['message'],
      compare: payload['compare'],
      url: "https://github.com/#{repository.full_name}.git",
      repository: repository)
  end

  def run_build
    OrchestrationWorker.create(:build_id => id)
  end

  def mark_build_finished
    average = average_response_from_endpoints
    status = status_from_endpoints
    pct_change = percent_change_from_last_build(average)
    self.update_attributes!(
      build_status: status,
      average_response: average,
      percent_change: pct_change)
  end

  def mark_build_error(message = nil)
    self.update_attributes! build_status: :error, error_message: message
  end

  #TODO: prob need to add build endpoints here and then update them later
  #      in case some of them don't come back
  def add_endpoint(url, headers, attribs = {})
    # Add other options to where clause to make them unique endpoints
    endpoint = repository.endpoints.where({url: url}.merge(attribs)).first
    unless endpoint
      endpoint = Endpoint.create!({repository: repository, url: url,
        headers: JSON.generate(headers)}.merge(attribs))
    end
    endpoint
  end

  def update_status(status, pct_done)
    update_attributes! build_status:status,percent_done:pct_done
  end

  def configure_build(yaml_hash)
    (yaml_hash['endpoints'] || []).each do |e|
      add_endpoint(
        e['url'],
        (e['headers'] || {}).to_hash,
        max_response_time: e['max_response_time'],
        name: e['name'])
    end
  end

  def build_status_message
    Build.message_for_status(build_status)
  end

  def endpoint_benchmark(endpoint, average_response, score, data)
    #TODO: Move this to endpoint model with easier API
    build_endpoints.create!(
      response_time: average_response,
      score: score,
      data: JSON.generate(data),
      endpoint: endpoint,
      build: self)
  end

  def mark_endpoint_error(endpoint, error_message = "")
    build_endpoints.create!(
      response_time: 0,
      score: 0,
      data: [].to_json,
      endpoint: endpoint,
      #error_message: error_message,  #TODO
      status: :error,
      build: self)
  end

  def self.message_for_status(status)
    case (status || '').to_sym
    when :cloning
      "Cloning Code"
    when :preparing_target
      "Remote Target Preparations"
    when :pending
      "Waiting to Build"
    when :building_container
      "Building Docker Container"
    when :attacking_container
      "Benchmarking Container"
    when :saving_results
      "Saving Results"
    when :success
      "Success"
    when :failed
      "Build Failed: Endpoint exceeded maximum response time"
    when :warn
      "Build Warning: Endpoint exceeded target response time"
    when :error
      "Build Error"
    else
      "Unknown"
    end
  end

  private
    def average_response_from_endpoints
      avg = self.build_endpoints.where('response_time IS NOT NULL').average(:response_time)
      avg || 0
    end

    def status_from_endpoints
      statuses = self.build_endpoints.pluck(:status)
      sorted_statuses = statuses.sort_by do |status|
        ranking = {'error' => 0, 'failed' => 1, 'warn' => 2, 'success' => 3}
      end
      worst_status = sorted_statuses.first || :success
    end

    def percent_change_from_last_build(avg_resp)
      last_build = repository.builds.order('created_at DESC').where("id <> ?", id).first
      if avg_resp && last_build && last_build.average_response
        (avg_resp - last_build.average_response) / last_build.average_response
      else
        0
      end
    end

end
