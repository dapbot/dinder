class AddFetchTimeForInstagramPhotos < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :instagram_photos_fetched_at, :datetime
  end
end
