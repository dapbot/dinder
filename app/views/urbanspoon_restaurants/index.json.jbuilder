json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :suburb, :address, :latitude, :longitude, :rating, :urbanspoon_id, :integer, :phone_number, :website
  json.url restaurant_url(restaurant, format: :json)
end
