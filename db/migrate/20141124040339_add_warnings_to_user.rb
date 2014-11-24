class AddWarningsToUser < ActiveRecord::Migration
  def change
    add_column :users, :ever_swiped_yes, :boolean, default: false
    add_column :users, :ever_swiped_no, :boolean, default: false
  end
end
