class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.integer :restaurant_id
      t.integer :day
      t.integer :opens_at
      t.integer :open_duration

      t.timestamps
    end
  end
end
