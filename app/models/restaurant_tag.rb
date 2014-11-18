# == Schema Information
#
# Table name: restaurant_tags
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  tag_id        :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class RestaurantTag < ActiveRecord::Base

  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates_presence_of :tag_id
  validates_presence_of :taggable_id
  validates_uniqueness_of :tag_id, :scope => :taggable_id

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
