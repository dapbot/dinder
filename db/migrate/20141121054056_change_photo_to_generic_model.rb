class ChangePhotoToGenericModel < ActiveRecord::Migration
  def change
    rename_table :instagram_photos, :photos
    add_column :photos, :source, :string
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE photos
          SET source='Instagram'
        SQL
      end
    end

  end
end
