class AddPrimaryPhotos < ActiveRecord::Migration
  def change
    add_column :restaurants, :photo_1, :integer
    add_column :restaurants, :photo_2, :integer
    add_column :restaurants, :photo_3, :integer
    add_column :urbanspoon_restaurants, :photo_1, :integer
    add_column :urbanspoon_restaurants, :photo_2, :integer
    add_column :urbanspoon_restaurants, :photo_3, :integer
    add_column :yelp_restaurants, :photo_1, :integer
    add_column :yelp_restaurants, :photo_2, :integer
    add_column :yelp_restaurants, :photo_3, :integer
    add_column :photos, :ignore, :boolean, default: false
  end
end
