# == Schema Information
#
# Table name: opening_periods
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  day           :integer
#  opens_at      :integer
#  closes_at     :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class OpeningPeriod < ActiveRecord::Base
	#opens at and closes at are measured in minutes since midnight sunday morning, so value is min 0 and max 10080

	belongs_to :restaurant
	
	def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
