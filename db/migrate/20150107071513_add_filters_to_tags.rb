class AddFiltersToTags < ActiveRecord::Migration
  def change
    add_column :tags, :clean_name, :string
    add_column :tags, :tag_type, :string
    add_column :tags, :ignore, :boolean, default: false
  end
end
