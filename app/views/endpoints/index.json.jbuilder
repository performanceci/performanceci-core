json.array!(@endpoints) do |endpoint|
  json.extract! endpoint, :id, :name, :url, :headers, :repository_id, :benchmark_type
  json.url endpoint_url(endpoint, format: :json)
end
