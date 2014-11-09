class RenameOpeningHour < ActiveRecord::Migration
  def change
  	rename_table :opening_hours, :opening_periods
  	rename_column :opening_periods, :open_duration, :closes_at
  	add_column :restaurants, :opening_hours_last_fetched, :datetime
  end
end
