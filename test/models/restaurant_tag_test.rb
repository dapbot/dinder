# == Schema Information
#
# Table name: restaurant_tags
#
#  id            :integer          not null, primary key
#  taggable_id   :integer
#  tag_id        :integer
#  created_at    :datetime
#  updated_at    :datetime
#  taggable_type :string(255)
#

require 'test_helper'

class RestaurantTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
