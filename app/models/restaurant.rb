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

class Restaurant < ActiveRecord::Base

  has_many :restaurant_tags
  has_many :tags, :through => :restaurant_tags

  has_many :opening_periods

  reverse_geocoded_by :latitude, :longitude

  def self.import_from_urbanspoon(start_page, end_page)
    agent = Mechanize.new
    agent.keep_alive = false
    agent.user_agent = "Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #pages 1 to 160
    (start_page..end_page).each do |page|
      listing_page = agent.get self.urbanspoon_page_url(page)
      listing_page.search("div.list.numbered").search("li.restaurant").each do |listing|
        #Grab the Urban Spoon ID
        restaurant_urbanspoon_id = listing["data-restaurant-id"]

        #Find existing record or create one from the URL
        restaurant = self.find_or_initialize_by(urbanspoon_id: restaurant_urbanspoon_id)

        #Add listing details
        restaurant.name = listing.search("div.title > a").text
        restaurant.suburb = listing.search("div.info > span.neighborhood").text.gsub(/\A(\s)+/, '').gsub(/(\s)+\z/, '')
        restaurant.rating = listing.search("div.title > span").text[0..1].to_i
        restaurant.url = "http://www.urbanspoon.com" + listing.search("div.title > a").first["href"]
        restaurant.price = 4 - listing.search("div.info > span.price > span.price-gray").text.length

        #Go to restaurant page and add page details
        sleep 0.5
        restaurant_page = agent.get restaurant.url
        address_details = restaurant_page.search("div.address-block")
        restaurant.address = address_details.search("span.street-address").text.gsub(/\A(\s)+/, '').gsub(/(\s)+\z/, '') + ", " + address_details.search("span.locality").text.gsub(/\n/, ' ').gsub(/\A(\s)+/, '').gsub(/(\s)+\z/, '')[0..-5].gsub(/(\s)+\z/, '')
        restaurant.phone_number = restaurant_page.search("a.phone.tel").length > 0 ? restaurant_page.search("a.phone.tel").text.gsub(/\n/, ' ') : ""
        restaurant.website = restaurant_page.search("div#weblinks-base > div > div > a").count > 0 ? restaurant_page.search("div#weblinks-base > div > div > a").first["href"] : ""
        restaurant.latitude = restaurant_page.search("meta[@property='urbanspoon:location:latitude']").first["content"].to_f
        restaurant.longitude = restaurant_page.search("meta[@property='urbanspoon:location:longitude']").first["content"].to_f

        restaurant.save

        #Add restaurant tags
        restaurant_page.search("div#cuisines-base > div > a").map(&:text).each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          new_restaurant_tag = restaurant.restaurant_tags.find_or_create_by(tag_id: tag.id)
        end

      end
    end
  end

  def self.refresh_opening_hours
    where("opening_hours_last_fetched < ? or opening_hours_last_fetched is null", Time.now - 14.days).each do |restaurant|
      restaurant.get_opening_periods
    end
  end

  def get_opening_periods
    google_info = self.find_on_google_places
    if google_info && google_info.opening_hours
      if google_info.opening_hours["periods"].count > 0
        google_info.opening_hours["periods"].each_with_index do |period, index|
          start_time = period["open"]["day"].to_i * 60 * 24 + period["open"]["time"][0..1].to_i * 60 + period["open"]["time"][2..3].to_i
          if period["close"]
            close_time = period["close"]["day"].to_i * 60 * 24 + period["close"]["time"][0..1].to_i * 60 + period["close"]["time"][2..3].to_i
          else
            #open 24 hours
            close_time = 7 * 24 * 60
          end
          opening_period = opening_periods[index] || opening_periods.build
          opening_period.opens_at = start_time
          opening_period.closes_at = close_time
          opening_period.save
        end
        if google_info.opening_hours["periods"].count < opening_periods.count
          [google_info.opening_hours["periods"].count .. opening_periods.count - 1].each do |index|
            opening_periods[index].destroy
          end
        end
      end
    end
    update_attributes(:opening_hours_last_fetched => Time.now)
  end

  def self.urbanspoon_page_url(page_number)
    "http://www.urbanspoon.com/lb/70/best-restaurants-Sydney?page=#{page_number}"
  end

  def find_on_yelp
    agent = Mechanize.new
    agent.keep_alive = false
    agent.user_agent = "Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    search_results = agent.get "http://www.yelp.com.au/search?find_desc=" + name.gsub(/[^A-Za-z0-9 ]/, "").gsub(/\s+/, "-") + "&find_loc=" + short_suburb.gsub(/[^A-Za-z0-9 ]/, "").gsub(/\s+/, "-") + "+Sydney+New+South+Wales&ns=1"
    biz_id = search_results.search("span.indexed-biz-name > a")[0]["href"][/[^?]+/][5..-1]
    puts biz_id
  end

  def find_on_google_places
    client = GooglePlaces::Client.new(GOOGLE_API_KEY)
    short_result = client.spots(latitude,longitude, :name => name.gsub(/[^A-Za-z0-9 ]/, ""), :types => 'food')[0]
    long_result = short_result ? client.spot(short_result.place_id) : nil
  end

  def short_suburb
    suburb[/[^,]+/]
  end

  scope :open_now, lambda{ where('EXISTS (SELECT 1 FROM opening_periods WHERE opening_periods.restaurant_id = restaurants.id AND opening_periods.opens_at < :current_time AND opening_periods.closes_at > :current_time)', current_time: (Time.now.wday * 24 * 60 + Time.now.hour * 60 + Time.now.min)) }

end