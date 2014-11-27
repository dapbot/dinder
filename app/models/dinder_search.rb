# == Schema Information
#
# Table name: dinder_searches
#
#  id              :integer          not null, primary key
#  lat_lng         :string(255)
#  no_restaurants  :text             default([]), is an Array
#  yes_restaurants :text             default([]), is an Array
#  session_id      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

class DinderSearch < ActiveRecord::Base
	has_many :unwanted_restaurant_tags
	has_many :unwanted_restaurants, through: :unwanted_restaurant_tags, source: :yelp_restaurant

  has_many :shortlistings
  has_many :shortlisted_restaurants, through: :shortlistings, source: :yelp_restaurant
  has_many :clicks

  belongs_to :user

  def distance_query
	 "(6371.0 * 2 * ASIN(SQRT(POWER(SIN((" + lat_lng.split("|")[0].to_s + " - yelp_restaurants.latitude) * PI() / 180 / 2), 2) + COS("  + lat_lng.split("|")[0].to_s + " * PI() / 180) * COS(yelp_restaurants.latitude * PI() / 180) * POWER(SIN(( " + lat_lng.split("|")[1].to_s + " - yelp_restaurants.longitude) * PI() / 180 / 2), 2))))"
  end

  def save_with_params(params)
    self.lat_lng = params[:lat_lng]
    save
    self
  end

	def results(restaurants_to_skip = nil)
    results = YelpRestaurant.where(nil)
    # results = results.select("dinder_score * ((0.85) ^ (#{distance_query} * 10)) as adjusted_dinder_score")
    results = results.select("(dinder_score * exp(-1.0 * exp(((#{distance_query}) * 4) - 4)))  * (1 - (0.20 * GREATEST(0, price - 2))) as adjusted_dinder_score")
    results = results.near(lat_lng.split("|"), 1.5)
    results = results.open_now
    results = results.affordable
    results = results.where("id NOT IN (?)", restaurants_to_skip) if restaurants_to_skip
    results = results.where("yelp_restaurants.id NOT IN (SELECT yelp_restaurant_id FROM unwanted_restaurant_tags WHERE dinder_search_id = #{self.id})") if unwanted_restaurants.count > 0
    results = results.where("yelp_restaurants.id NOT IN (SELECT yelp_restaurant_id FROM shortlistings WHERE dinder_search_id = #{self.id})") if shortlistings.count > 0
    # results = results.reorder("distance / 2 ASC").limit(10).sort_by {|r| r.distance_to( lat_lng.split("|") )}
    results = results.reorder("adjusted_dinder_score DESC").limit(50)
  end

  def add_no(restaurant_id)
  	self.unwanted_restaurant_tags.find_or_create_by(yelp_restaurant_id: restaurant_id)
    self.touch
  end

  def shortlist(restaurant_id)
    self.shortlistings.find_or_create_by(yelp_restaurant_id: restaurant_id)
    self.touch
  end

  def shortlisted_restaurants_by_distance(lat_lng)
    shortlisted_restaurants.near(lat_lng, 10)
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
