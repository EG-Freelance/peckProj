json.array!(@registries) do |registry|
  json.extract! registry, :id
  json.url registry_url(registry, format: :json)
end
