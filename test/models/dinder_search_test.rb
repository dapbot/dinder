# == Schema Information
#
# Table name: dinder_searches
#
#  id              :integer          not null, primary key
#  lat_lng         :string(255)
#  no_restaurants  :text             default([]), is an Array
#  yes_restaurants :text             default([]), is an Array
#  session_id      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

require 'test_helper'

class DinderSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
