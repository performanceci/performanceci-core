json.array!(@builds) do |build|
  json.extract! build, :id, :ref, :before, :after, :repository_id, :message, :url, :author, :payload
  json.url build_url(build, format: :json)
end
