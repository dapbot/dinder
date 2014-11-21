class Shortlisting < ActiveRecord::Base
  belongs_to :yelp_restaurant
  belongs_to :dinder_search
end
