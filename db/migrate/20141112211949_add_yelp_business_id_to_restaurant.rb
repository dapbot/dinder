class AddYelpBusinessIdToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :yelp_business_id, :string
  end
end
