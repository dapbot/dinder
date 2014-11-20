class DinderSearch < ActiveRecord::Base
	has_many :unwanted_restaurant_tags
	has_many :unwanted_restaurants, through: :unwanted_restaurant_tags, source: :yelp_restaurant

	DISTANCE_QUERY = "(6371.0 * 2 * ASIN(SQRT(POWER(SIN((-33.8976859 - yelp_restaurants.latitude) * PI() / 180 / 2), 2) + COS(-33.8976859 * PI() / 180) * COS(yelp_restaurants.latitude * PI() / 180) * POWER(SIN((151.2102778 - yelp_restaurants.longitude) * PI() / 180 / 2), 2))))"
	
	def self.create_with_params(params)
		search = self.new
		search.lat_lng = params[:lat_lng]
		search.save
		search
	end

	def results
    results = YelpRestaurant.where(nil)
    results = results.near(lat_lng.split("|"), 1)
    results = results.open_now
    results = results.affordable
    results = results.where("yelp_restaurants.id NOT IN (SELECT yelp_restaurant_id FROM unwanted_restaurant_tags WHERE dinder_search_id = #{self.id})") if unwanted_restaurants.count > 0
    # results = results.reorder("distance / 2 ASC").limit(10).sort_by {|r| r.distance_to( lat_lng.split("|") )}
    results = results.reorder("(COALESCE(rating, 0) + (sqrt(sqrt(COALESCE(review_count, 0)))) + ((1 / #{DISTANCE_QUERY}))) DESC").limit(50)
  end

  def add_no(restaurant_id)
  	self.unwanted_restaurant_tags.find_or_create_by(yelp_restaurant_id: restaurant_id)
  end


  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
