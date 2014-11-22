class AddToYelpRestaurant < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :yelp_photos_last_fetched_at, :datetime
  end
end
