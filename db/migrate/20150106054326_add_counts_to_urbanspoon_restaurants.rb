class AddCountsToUrbanspoonRestaurants < ActiveRecord::Migration
  def change
    add_column :urbanspoon_restaurants, :review_count, :integer
    add_column :urbanspoon_restaurants, :vote_count, :integer
  end
end
