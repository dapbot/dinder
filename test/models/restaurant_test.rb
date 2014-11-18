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
#  url                        :text
#  price                      :integer
#  urbanspoon_id              :string(255)
#  phone_number               :string(255)
#  website                    :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  opening_hours_last_fetched :datetime
#  google_place_id            :string(255)
#  urbanspoon_ranking         :integer
#  yelp_price                 :integer
#  yelp_take_away             :boolean
#  yelp_good_for_groups       :boolean
#  yelp_good_for_children     :boolean
#  yelp_noise_level           :integer
#  yelp_alcohol               :string(255)
#  yelp_reservations          :boolean
#  yelp_ambience              :string(255)
#  yelp_score                 :float
#  yelp_review_count          :integer
#  yelp_photo_url             :text
#  yelp_business_id           :string(255)
#  yelp_last_fetched          :datetime
#

require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
