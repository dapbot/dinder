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

	belongs_to :openable, polymorphic: true

	def opens_at_24
		opens_at % (24 * 60)
	end

	def closes_at_24
		closes_at % (24 * 60)
	end
	
	def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def self.from_monday
  	order("((opens_at + 8640) % 10080) ASC")
  end
end
