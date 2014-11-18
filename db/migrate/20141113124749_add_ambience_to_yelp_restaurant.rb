class AddAmbienceToYelpRestaurant < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :ambience, :string
  end
end
