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

require 'test_helper'

class RestaurantTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
