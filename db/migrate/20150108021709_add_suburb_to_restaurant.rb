class AddSuburbToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :suburb, :string
  end
end
