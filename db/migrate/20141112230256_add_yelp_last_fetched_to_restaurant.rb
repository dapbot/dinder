class AddYelpLastFetchedToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :yelp_last_fetched, :datetime
  end
end
