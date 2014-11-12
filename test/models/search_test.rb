# == Schema Information
#
# Table name: searches
#
#  id           :integer          not null, primary key
#  open_now     :boolean
#  open_at      :datetime
#  lat_lng      :string(255)
#  cheaper_than :integer
#  fancier_than :integer
#  not_cuisines :text             default([]), is an Array
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
