json.array!(@clicks) do |click|
  json.extract! click, :id, :create
  json.url click_url(click, format: :json)
end
