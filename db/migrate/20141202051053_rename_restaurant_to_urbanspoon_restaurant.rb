class RenameRestaurantToUrbanspoonRestaurant < ActiveRecord::Migration
  def change
    remove_column :restaurants, :yelp_price, :integer
    remove_column :restaurants, :yelp_take_away, :boolean
    remove_column :restaurants, :yelp_good_for_groups, :boolean
    remove_column :restaurants, :yelp_good_for_children, :boolean
    remove_column :restaurants, :yelp_noise_level, :integer
    remove_column :restaurants, :yelp_alcohol, :string
    remove_column :restaurants, :yelp_reservations, :boolean
    remove_column :restaurants, :yelp_ambience, :string
    remove_column :restaurants, :yelp_score, :float
    remove_column :restaurants, :yelp_review_count, :integer
    remove_column :restaurants, :yelp_photo_url, :text
    rename_table :restaurants, :urbanspoon_restaurants
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE opening_periods
          SET openable_type='UrbanspoonRestaurant'
          WHERE openable_type='Restaurant'
        SQL
        execute <<-SQL
          UPDATE restaurant_tags
          SET taggable_type='UrbanspoonRestaurant'
          WHERE taggable_type='Restaurant'
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE opening_periods
          SET openable_type='Restaurant'
          WHERE openable_type='UrbanspoonRestaurant'
        SQL
        execute <<-SQL
          UPDATE restaurant_tags
          SET taggable_type='Restaurant'
          WHERE taggable_type='UrbanspoonRestaurant'
        SQL
      end
    end
  end
end
