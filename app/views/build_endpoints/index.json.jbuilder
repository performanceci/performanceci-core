json.array!(@build_endpoints) do |build_endpoint|
  json.extract! build_endpoint, :id, :endpoint_id, :build_id, :data, :response_time, :score, :screenshot
  json.url build_endpoint_url(build_endpoint, format: :json)
end
