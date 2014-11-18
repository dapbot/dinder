class MakeOpeningPeriodsPolymorphic < ActiveRecord::Migration
  def change
  	rename_column :opening_periods, :restaurant_id, :openable_id
  	add_column :opening_periods, :openable_type, :string
  	rename_column :restaurant_tags, :restaurant_id, :taggable_id
  	add_column :restaurant_tags, :taggable_type, :string

  	reversible do |dir|
      dir.up do
        #add a foreign key
        execute <<-SQL
          UPDATE restaurant_tags
          SET taggable_type='Restaurant'
        SQL
        execute <<-SQL
          UPDATE opening_periods
          SET openable_type='Restaurant'
        SQL
      end
    end
  end
end
