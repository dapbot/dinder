class CreateUnwantedRestaurants < ActiveRecord::Migration
  def change
    create_table :unwanted_restaurant_tags do |t|
      t.integer :restaurant_id
      t.integer :dinder_search_id

      t.timestamps
    end
  end
end
