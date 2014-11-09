class RenameRestaurant < ActiveRecord::Migration
  def change
  	rename_table :urbanspoon_restaurants, :restaurants
  end
end
