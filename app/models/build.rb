class Build < ActiveRecord::Base
  belongs_to :repository

  has_many :build_endpoints

  scope :ongoing, -> { where("build_status NOT IN(?)", %w(success failed error))}

  BUILD_STATUSES = %w(pending building_container attacking_container success failed warn error)

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

  def mark_build_finished
    average = average_response_from_endpoints
    status = status_from_endpoints
    pct_change = percent_change_from_last_build(average)
    self.update_attributes!(
      build_status: status,
      average_response: average,
      percent_change: pct_change)
  end

  def mark_build_error
    self.update_attributes! build_status: :error
  end

  #TODO: prob need to add build endpoints here and then update them later
  #      in case some of them don't come back
  def add_endpoint(url, headers, options = {})
    # Add other options to where clause to make them unique endpoints
    endpoint = repository.endpoints.where(url: url).first
    unless endpoint
      endpoint = Endpoint.create!({repository: repository, url: url,
        headers: JSON.generate(headers)}.merge(options))
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
      error_message: error_message,
      status: :error,
      build: self)
  end

  def generate_fake_data(n)
    (1..n).each do |i|
      endpoint = add_endpoint("http://localhost:3000/api/endpoint#{i}", {})
      data, score, avg_resp = fake_benchmarks(10)
      endpoint_benchmark(endpoint, avg_resp, score, data)
    end
    mark_build_finished
  end

  def fake_benchmarks(n)
    data = (1..n).map { rand(1000) }
    [data, rand(11), data.inject(:+) / n.to_f]
  end

  def self.message_for_status(status)
    case (status || '').to_sym
    when :pending
      "Waiting to Build"
    when :building_container
      "Building Docker Container"
    when :attacking_container
      "Benchmarking Container"
    when :success
      "Success"
    when :failed
      "Build Failed: Endpoint exceeded maximum response time"
    when :warn
      "Build Warning: Endpoint exceeded target response time"
    when :error
      "Build Error: #{error_message}"
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
