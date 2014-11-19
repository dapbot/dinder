class CreateInstagramPhotos < ActiveRecord::Migration
  def change
    create_table :instagram_photos do |t|
      t.integer :yelp_restaurant_id
      t.text :low_resolution_url
      t.text :medium_resolution_url
      t.text :high_resolution_url

      t.timestamps
    end
  end
end
