class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude
      t.string :phone_number
      t.text :website
      t.float :dinder_score
      t.integer :price

      t.timestamps
    end
    add_column :yelp_restaurants, :restaurant_id, :integer
    add_column :urbanspoon_restaurants, :restaurant_id, :integer
  end
end
