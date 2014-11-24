# == Schema Information
#
# Table name: unwanted_restaurant_tags
#
#  id                 :integer          not null, primary key
#  yelp_restaurant_id :integer
#  dinder_search_id   :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class UnwantedRestaurantTag < ActiveRecord::Base
	belongs_to :yelp_restaurant
	belongs_to :dinder_search
end
