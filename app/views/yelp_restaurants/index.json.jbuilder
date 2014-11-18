json.array!(@yelp_restaurants) do |yelp_restaurant|
  json.extract! yelp_restaurant, :id
  json.url yelp_restaurant_url(yelp_restaurant, format: :json)
end
