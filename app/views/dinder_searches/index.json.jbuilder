json.array!(@dinder_searches) do |dinder_search|
  json.extract! dinder_search, :id
  json.url dinder_search_url(dinder_search, format: :json)
end
