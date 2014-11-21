class AddDinderScoreToYelpRestaurant < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :dinder_score, :float
  end
end
