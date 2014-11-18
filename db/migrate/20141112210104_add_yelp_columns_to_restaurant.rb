class AddYelpColumnsToRestaurant < ActiveRecord::Migration
  def change
  	add_column :restaurants, :yelp_price, :integer
  	add_column :restaurants, :yelp_take_away, :boolean
  	add_column :restaurants, :yelp_good_for_groups, :boolean
  	add_column :restaurants, :yelp_good_for_children, :boolean
  	add_column :restaurants, :yelp_noise_level, :integer
  	add_column :restaurants, :yelp_alcohol, :string
  	add_column :restaurants, :yelp_reservations, :boolean
  	add_column :restaurants, :yelp_ambience, :string
  	add_column :restaurants, :yelp_score, :float
  	add_column :restaurants, :yelp_review_count, :integer
  	add_column :restaurants, :yelp_photo_url, :text
  end
end
