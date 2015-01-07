# == Schema Information
#
# Table name: restaurants
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :text
#  latitude     :float
#  longitude    :float
#  phone_number :string(255)
#  website      :text
#  dinder_score :float
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
