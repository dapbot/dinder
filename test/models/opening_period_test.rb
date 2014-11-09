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

require 'test_helper'

class OpeningHourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
