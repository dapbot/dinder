# == Schema Information
#
# Table name: yelp_restaurants
#
#  id                          :integer          not null, primary key
#  yelp_id                     :string(255)
#  name                        :string(255)
#  address_street              :string(255)
#  address_suburb              :string(255)
#  address_state               :string(255)
#  address_post_code           :string(255)
#  phone_number                :string(255)
#  website                     :text
#  rating                      :float
#  review_count                :integer
#  latitude                    :float
#  longitude                   :float
#  fetched_at                  :datetime
#  price                       :integer
#  take_away                   :boolean
#  good_for_groups             :boolean
#  good_for_children           :boolean
#  noise_level                 :integer
#  alcohol                     :string(255)
#  reservations                :boolean
#  photo_url                   :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  ambience                    :string(255)
#  instagram_photos_fetched_at :datetime
#  dinder_score                :float
#  yelp_photos_last_fetched_at :datetime
#  restaurant_id               :integer
#

require 'test_helper'

class YelpRestaurantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
