class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :user_id
      t.integer :dinder_search_id
      t.string :clickable_type
      t.integer :clickable_id
      t.string :purpose
      t.integer :yelp_restaurant_id

      t.timestamps
    end
  end
end
