class AddUrbanspoonRankingToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :urbanspoon_ranking, :integer
  end
end
