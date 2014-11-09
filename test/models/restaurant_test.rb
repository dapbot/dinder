# == Schema Information
#
# Table name: restaurants
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  suburb                     :string(255)
#  address                    :text
#  latitude                   :float
#  longitude                  :float
#  rating                     :integer
#  url                        :string(255)
#  price                      :integer
#  urbanspoon_id              :string(255)
#  phone_number               :string(255)
#  website                    :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  opening_hours_last_fetched :datetime
#

require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
