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

class Restaurant < ActiveRecord::Base
  has_many :yelp_restaurants, dependent: :nullify
  has_many :urbanspoon_restaurants, dependent: :nullify

  belongs_to :photo_1, :class_name => 'Photo', :foreign_key => 'photo_1_id'
  belongs_to :photo_2, :class_name => 'Photo', :foreign_key => 'photo_2_id'
  belongs_to :photo_3, :class_name => 'Photo', :foreign_key => 'photo_3_id'

  def populate_data
    self.name = (primary_us || primary_yelp).name
    self.address = (primary_us || primary_yelp).address
    self.suburb = (primary_us || primary_yelp).suburb
    self.latitude = (primary_us || primary_yelp).latitude
    self.longitude = (primary_us || primary_yelp).longitude
    self.phone_number = (primary_us || primary_yelp).phone_number
    self.website = (primary_us || primary_yelp).website
    prices = ((primary_us && primary_us.price ? [primary_us.price] : []) + (primary_yelp && primary_yelp.price ? [primary_yelp.price] : []))
    self.price = (prices.sum / prices.length).floor if prices.length > 0
    #NEED TO CHANGE NEXT LINE WHEN DINDER SCORES HAVE BEEN CALCULATED
    self.dinder_score = has_yelp ? primary_yelp.dinder_score : 0
    self.save
  end

  def has_us
    urbanspoon_restaurants.length > 0
  end

  def has_yelp
    yelp_restaurants.length > 0
  end

  def primary_us
    urbanspoon_restaurants.order("vote_count DESC").first
  end

  def primary_yelp
    yelp_restaurants.order("review_count DESC").first
  end

  def tags
    Tag.where("tags.id IN ((SELECT tag_id FROM restaurant_tags WHERE taggable_type = 'YelpRestaurant' and taggable_id IN (SELECT id FROM yelp_restaurants WHERE restaurant_id = #{self.id})) UNION ALL (SELECT tag_id FROM restaurant_tags WHERE taggable_type = 'UrbanspoonRestaurant' and taggable_id IN (SELECT id FROM urbanspoon_restaurants WHERE restaurant_id = #{self.id})))")
  end

  def photos
    Photo.where("(photographable_type = 'YelpRestaurant' and photographable_id IN (SELECT id FROM yelp_restaurants WHERE restaurant_id = #{self.id})) OR (photographable_type = 'UrbanspoonRestaurant' and photographable_id IN (SELECT id FROM urbanspoon_restaurants WHERE restaurant_id = #{self.id}))")
  end

  def photo_1_id=(photo)
    super(photo)
    child_restaurants.each do |child|
      child.photo_1_id = self.photo_1_id
      child.save
    end
  end

  def photo_2_id=(photo)
    super(photo)
    child_restaurants.each do |child|
      child.photo_2_id = self.photo_2_id
      child.save
    end
  end

  def photo_3_id=(photo)
    super(photo)
    child_restaurants.each do |child|
      child.photo_3_id = self.photo_3_id
      child.save
    end
  end

  def child_restaurants
    urbanspoon_restaurants + yelp_restaurants
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << (column_names + ["primary_yelp_id", "yelp_duplicate_count", "aggregate_yelp_review_count", "weighted_avg_yelp_score", "primary_us_id", "us_duplicate_count", "aggregate_us_review_count", "weight_avg_us_score"])
      all.each do |restaurant|
        row = restaurant.attributes.values_at(*column_names)

        if restaurant.has_yelp
          row.push restaurant.primary_yelp.yelp_id
          row.push restaurant.yelp_restaurants.length
          if restaurant.yelp_restaurants.length > 1
            review_count = restaurant.yelp_restaurants.map{|r| r.review_count || 0}.sum
            row.push review_count
            row.push (review_count > 0 ? restaurant.yelp_restaurants.map{|r| r.rating ? r.rating * (r.review_count || 0) : 0}.sum / review_count : 0)
          else
            row.push restaurant.primary_yelp.review_count
            row.push restaurant.primary_yelp.rating
          end
        else
          row.push nil,nil,nil,nil
        end

        if restaurant.has_us
          row.push restaurant.primary_us.urbanspoon_id
          row.push restaurant.urbanspoon_restaurants.length
          if restaurant.urbanspoon_restaurants.length > 1
            review_count = restaurant.urbanspoon_restaurants.map{|r| r.vote_count || 0}.sum
            row.push review_count
            row.push (review_count > 0 ? restaurant.urbanspoon_restaurants.map{|r| r.rating ? r.rating * (r.vote_count || 0) : 0}.sum / review_count : 0)
          else
            row.push restaurant.primary_us.vote_count
            row.push restaurant.primary_us.rating
          end
        else
          row.push nil,nil,nil,nil
        end

        csv << row
      end
    end
  end
end