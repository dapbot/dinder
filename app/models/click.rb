# == Schema Information
#
# Table name: clicks
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  dinder_search_id   :integer
#  clickable_type     :string(255)
#  clickable_id       :integer
#  purpose            :string(255)
#  yelp_restaurant_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Click < ActiveRecord::Base
  belongs_to :dinder_search
  belongs_to :user
  belongs_to :clickable, polymorphic: true
  belongs_to :yelp_restaurant

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
