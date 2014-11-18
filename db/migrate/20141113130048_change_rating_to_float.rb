class ChangeRatingToFloat < ActiveRecord::Migration
  def change
  	change_column :yelp_restaurants, :rating, :float
  end
end
