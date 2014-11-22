class AddUserIdToDinderSearch < ActiveRecord::Migration
  def change
    add_column :dinder_searches, :user_id, :integer
  end
end
