# == Schema Information
#
# Table name: clicks
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  dinder_search_id   :integer
#  clickable_type     :string(255)
#  clickable_id       :integer
#  purpose            :string(255)
#  yelp_restaurant_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class ClickTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
