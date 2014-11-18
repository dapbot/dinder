class CreateDinderSearches < ActiveRecord::Migration
  def change
    create_table :dinder_searches do |t|
      t.string :lat_lng
      t.text :no_restaurants, array: true, default: []
      t.text :yes_restaurants, array: true, default: []
      t.string :session_id

      t.timestamps
    end
  end
end
