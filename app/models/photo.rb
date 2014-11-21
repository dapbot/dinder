class Photo < ActiveRecord::Base
  belongs_to :yelp_restaurant

  def self.from_source(source)
    where("source = '#{source}'")
  end
end
