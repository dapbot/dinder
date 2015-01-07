class ChangePhotoToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :photos, :yelp_restaurant_id, :photographable_id
    add_column :photos, :photographable_type, :string

    reversible do |dir|
      dir.up do
        #add a foreign key
        execute <<-SQL
          UPDATE photos
          SET photographable_type='YelpRestaurant'
        SQL
      end
    end
  end
end