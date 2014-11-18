class CreateYelpRestaurants < ActiveRecord::Migration
  def change
    create_table :yelp_restaurants do |t|
      t.string :yelp_id
      t.string :name
      t.string :address_street
      t.string :address_suburb
      t.string :address_state
      t.string :address_post_code
      t.string :phone_number
      t.text :website
      t.integer :rating
      t.integer :review_count
      t.float :latitude
      t.float :longitude
      t.datetime :fetched_at
      t.integer :price
      t.boolean :take_away
      t.boolean :good_for_groups
      t.boolean :good_for_children
      t.integer :noise_level
      t.string :alcohol
      t.boolean :reservations
      t.text :photo_url

      t.timestamps
    end
  end
end
