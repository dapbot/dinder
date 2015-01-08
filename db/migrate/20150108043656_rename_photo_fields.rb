class RenamePhotoFields < ActiveRecord::Migration
  def change
    rename_column :restaurants, :photo_1, :photo_1_id
    rename_column :restaurants, :photo_2, :photo_2_id
    rename_column :restaurants, :photo_3, :photo_3_id
    rename_column :urbanspoon_restaurants, :photo_1, :photo_1_id
    rename_column :urbanspoon_restaurants, :photo_2, :photo_2_id
    rename_column :urbanspoon_restaurants, :photo_3, :photo_3_id
    rename_column :yelp_restaurants, :photo_1, :photo_1_id
    rename_column :yelp_restaurants, :photo_2, :photo_2_id
    rename_column :yelp_restaurants, :photo_3, :photo_3_id
  end
end
