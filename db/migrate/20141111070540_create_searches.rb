class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.boolean :open_now
      t.datetime :open_at
      t.string :lat_lng
      t.integer :cheaper_than
      t.integer :fancier_than
      t.text :not_cuisines, array: true, default: []
      t.integer :user_id

      t.timestamps
    end
  end
end
