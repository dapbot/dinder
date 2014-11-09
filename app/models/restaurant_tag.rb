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
  belongs_to :restaurant

  validates_presence_of :tag_id
  validates_presence_of :restaurant_id
  validates_uniqueness_of :tag_id, :scope => :restaurant_id

end
