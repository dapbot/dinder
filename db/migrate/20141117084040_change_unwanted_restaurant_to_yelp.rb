class ChangeUnwantedRestaurantToYelp < ActiveRecord::Migration
  def change
  	rename_column :unwanted_restaurant_tags, :restaurant_id, :yelp_restaurant_id
  end
end
