class CreateShortlistings < ActiveRecord::Migration
  def change
    create_table :shortlistings do |t|
      t.integer :yelp_restaurant_id
      t.integer :dinder_search_id

      t.timestamps
    end
  end
end
