class CreateUrbanspoonRestaurants < ActiveRecord::Migration
  def change
    create_table :urbanspoon_restaurants do |t|
      t.string :name
      t.string :suburb
      t.text :address
      t.float :latitude
      t.float :longitude
      t.integer :rating
      t.string :url
      t.integer :price
      t.string :urbanspoon_id
      t.string :phone_number
      t.string :website

      t.timestamps
    end
  end
end
