class DinderSearch < ActiveRecord::Base
	has_many :unwanted_restaurant_tags
	has_many :unwanted_restaurants, through: :unwanted_restaurant_tags, source: :yelp_restaurant

  has_many :shortlistings
  has_many :shortlisted_restaurants, through: :shortlistings, source: :yelp_restaurant

  def distance_query
	 "(6371.0 * 2 * ASIN(SQRT(POWER(SIN((" + lat_lng.split("|")[0].to_s + " - yelp_restaurants.latitude) * PI() / 180 / 2), 2) + COS("  + lat_lng.split("|")[0].to_s + " * PI() / 180) * COS(yelp_restaurants.latitude * PI() / 180) * POWER(SIN(( " + lat_lng.split("|")[1].to_s + " - yelp_restaurants.longitude) * PI() / 180 / 2), 2))))"
  end
	
	def self.create_with_params(params)
		search = self.new
		search.lat_lng = params[:lat_lng]
		search.save
		search
	end

	def results
    results = YelpRestaurant.where(nil)
    results = results.select("dinder_score * ((0.85) ^ (#{distance_query} * 10)) as adjusted_dinder_score")
    results = results.near(lat_lng.split("|"), 1.5)
    results = results.open_now
    results = results.where("yelp_restaurants.id NOT IN (SELECT yelp_restaurant_id FROM unwanted_restaurant_tags WHERE dinder_search_id = #{self.id})") if unwanted_restaurants.count > 0
    results = results.where("yelp_restaurants.id NOT IN (SELECT yelp_restaurant_id FROM shortlistings WHERE dinder_search_id = #{self.id})") if shortlistings.count > 0
    # results = results.reorder("distance / 2 ASC").limit(10).sort_by {|r| r.distance_to( lat_lng.split("|") )}
    results = results.reorder("adjusted_dinder_score DESC").limit(50)
  end

  def add_no(restaurant_id)
  	self.unwanted_restaurant_tags.find_or_create_by(yelp_restaurant_id: restaurant_id)
  end

  def shortlist(restaurant_id)
    self.shortlistings.find_or_create_by(yelp_restaurant_id: restaurant_id)
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
