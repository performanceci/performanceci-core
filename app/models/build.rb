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
    build_endpoints.create!(
      response_time: average_response,
      score: score,
      data: JSON.generate(data),
      endpoint: endpoint,
      build: self)
  end

  def generate_fake_data(n)
    (1..n).each do |i|
      endpoint = add_endpoint("http://localhost:3000/api/endpoint#{i}", {})
      data, score, avg_resp = fake_benchmarks(10)
      endpoint_benchmark(endpoint, avg_resp, score, data)
    end
  end

  def fake_benchmarks(n)
    data = (1..n).map { rand(1000) }
    [data, rand(11), data.inject(:+) / n.to_f]
  end

end
