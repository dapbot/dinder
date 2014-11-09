class ChangeWebsiteToText < ActiveRecord::Migration
  def change
  	 change_column :restaurants, :website, :text
  	 change_column :restaurants, :url, :text
  end
end
