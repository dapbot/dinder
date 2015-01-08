json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :suburb, :address, :latitude, :longitude, :phone_number, :website
  json.url restaurant_url(restaurant, format: :json)
end
