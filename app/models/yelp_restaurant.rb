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
#

class YelpRestaurant < ActiveRecord::Base
  
  START_LAT = -33.923113
  END_LAT = -33.816499
  TILE_HEIGHT = (END_LAT - START_LAT) / 8.0
  START_LONG = 151.148625
  END_LONG = 151.301061
  TILE_WIDTH = (END_LONG - START_LONG) / 8.0

  has_many :opening_periods, as: :openable
  has_many :restaurant_tags, as: :taggable
  has_many :tags, :through => :restaurant_tags

  reverse_geocoded_by :latitude, :longitude

  has_many :photos
  has_many :clicks

  def best_photos
    photos.from_source("Yelp").length > 5 ? photos.from_source("Yelp") : photos.from_source("Yelp") + photos.from_source("Instagram")
  end

  def open_state
    current_time = Time.zone.now.wday * 24 * 60 + Time.zone.now.hour * 60 + Time.zone.now.min
    if Time.zone.now.hour > 15 && Time.zone.now.hour < 20
      current_time_increment = 300
    else
      current_time_increment = 60
    end
    current_opening_period = self.opening_periods.where("opens_at < :current_time_plus_one and closes_at > :current_time", current_time_plus_one: current_time + current_time_increment, current_time: current_time).first
    state = ""
    if current_opening_period.nil? == false
      if current_opening_period.closes_at - current_time < 240
        # state = "Closes in " + (current_opening_period.closes_at - current_time).to_s + " mins"
        state = "Closes at " + ((current_opening_period.closes_at_24 % (12 * 60)) / 60).floor.to_s + ":" + ("%02d" % (current_opening_period.closes_at_24 % 60)) + (current_opening_period.closes_at_24 > (12 * 60) ? "PM" : "AM")
        if (next_opening = self.opening_periods.where("opens_at > ? and opens_at < ?", current_opening_period.closes_at, (1 + Time.zone.now.wday) * 24 * 60).first).nil? == false
          state += ", opens again at " + ((next_opening.opens_at_24 % (12 * 60)) / 60).floor.to_s + ":" + ("%02d" % (next_opening.opens_at_24 % 60)) + (next_opening.opens_at_24 > (12 * 60) ? "PM" : "AM")
        end
      end
      if current_opening_period.opens_at - current_time > 0
        # if current_opening_period.opens_at - current_time < 60
        #   state = "Opens in " + (current_opening_period.opens_at - current_time).to_s + " mins" 
        # else
          state = "Opens at " + ((current_opening_period.opens_at_24 % (12 * 60)) / 60).floor.to_s + ":" + ("%02d" % (current_opening_period.opens_at_24 % 60)) + (current_opening_period.opens_at_24 > (12 * 60) ? "PM" : "AM")
        # end
      end
    end
    state
  end

  def description
    result = ""
    result += tags.map(&:name).map{|r| r.gsub(/\n/,"")}.map(&:strip).join(", ") + (tags.length > 0 ? ", " : "")
    result += good_for_groups ? "Good for groups, " : ""
    result += noise_level && noise_level > 2 ? "Noisy, " : "" 
    result += ambience.nil? ? "" : ambience + ", "
    result = result[0..-3]
    result = result[0..45] + "..." if result.length > 60
    result.html_safe
  end

  def price_html
    self.price.nil? ? "" : "<span class='highlight'>" + ("$" * price) + "</span>" + ("$" * (4 - price))
  end

  def dinder_score_colour
    if dinder_score > 75
      "green"
    elsif dinder_score > 50
      "amber"
    else
      "red"
    end
  end

  def paramaterised_address
    address_street.gsub(/\s/, "+").gsub(/[\,\/\\]/,"") + "+" + address_suburb + "+" + address_state + "+" + address_post_code 
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
    end
  end

  def on_urbanspoon
    Restaurant.where("latitude > ? and latitude < ? and longitude > ? and longitude < ?", latitude - 0.005, latitude + 0.005, longitude - 0.005, longitude + 0.005).select{|x| x.name.similarity_to(self.name) > 0.3}.sort{|x,y| self.name.similarity_to(x.name) <=> self.name.similarity_to(y.name)}[-1]
  end

  def self.accessible_attributes
    ["dinder_score"]
  end

  def self.yelp_search_url(query_num)
    # Area is divided into 64 tiles
    query_start_lat = START_LAT + (TILE_HEIGHT * (query_num % 8))
    query_end_lat = query_start_lat + TILE_HEIGHT
    query_start_long = START_LONG + (TILE_WIDTH * (query_num / 8).floor)
    query_end_long = query_start_long + TILE_WIDTH
    "http://www.yelp.com.au/search?find_loc=sydney%2C+New+South+Wales&ns=1&cflt=restaurants&l=g:" + query_start_long.to_s + "," + query_start_lat.to_s + "," + query_end_long.to_s + "," + query_end_lat.to_s
  end

  def self.fetch(start_query, end_query, resume_at_page = 0, total_page_count = nil, force_refresh = false)
 		#Up to query 50 page 18
    agent = Mechanize.new
    agent.keep_alive = false
    agent.user_agent = "Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"
    agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #queries 0 to 63
    (start_query..end_query).each do |query|
    	page_count = query == start_query ? resume_at_page : 0
      #keep progressing through the pages
      loop do
      	puts "WORKING ON QUERY#" + query.to_s + ", PAGE #" + page_count.to_s
        next_page = self.yelp_search_url(query) + "&start=" + (page_count * 10).to_s
        listing_page = agent.get next_page
        sleep 2.5
        listings = listing_page.search("li > div.search-result")
        break if listings.count == 0
        listings.each do |listing|
        	puts "WORKING ON QUERY#" + query.to_s + ", PAGE #" + page_count.to_s
          restaurant_url = listing.search("span.indexed-biz-name > a")[0]["href"]
          yelp_id = restaurant_url.match(/[^\/]+$/)[0]
          if force_refresh or find_by_yelp_id(yelp_id).nil?
	          restaurant_page = agent.get restaurant_url
	          sleep 1

	          #Find existing record or create one from the URL
	          restaurant = self.find_or_initialize_by(yelp_id: yelp_id)

	          #Add listing details
	          restaurant.name = ActiveSupport::Inflector.transliterate(restaurant_page.search("h1.biz-page-title").text.gsub(/\n/,"").strip)
	          restaurant.address_street = restaurant_page.search("strong.street-address > address > span[itemprop='streetAddress']").text
	          restaurant.address_suburb = restaurant_page.search("strong.street-address > address > span[itemprop='addressLocality']").text
	          restaurant.address_state = restaurant_page.search("strong.street-address > address > span[itemprop='addressRegion']").text
	          restaurant.address_post_code = restaurant_page.search("strong.street-address > address > span[itemprop='postalCode']").text
	          restaurant.phone_number = restaurant_page.search("span.biz-phone").text.gsub(/\n/,"").strip if restaurant_page.search("span.biz-phone").count > 0

	          #Go to restaurant page and add page details
	          restaurant.website = "http://" + restaurant_page.search("div.biz-website > a").first.text.gsub(/\n/,"").strip if restaurant_page.search("div.biz-website > a").count > 0
	          restaurant.latitude = restaurant_page.search("div.lightbox-map.hidden").first.attributes["data-map-state"].text.scan(/[\-]?[0-9]+\.[0-9]+/)[0].to_f
	          restaurant.longitude = restaurant_page.search("div.lightbox-map.hidden").first.attributes["data-map-state"].text.scan(/[\-]?[0-9]+\.[0-9]+/)[1].to_f

	          restaurant.rating = restaurant_page.search("div.biz-rating > div.rating-very-large > meta").first.attributes["content"].value.to_f if restaurant_page.search("div.biz-rating > div.rating-very-large > meta").count > 0
	          restaurant.price = restaurant_page.search("div.price-category > span.bullet-after > span.price-range").text.count("$") if restaurant_page.search("div.price-category > span.bullet-after > span.price-range").count > 0
	          restaurant.review_count = restaurant_page.search("div.rating-info > div.biz-rating > span.review-count > span").text.to_i if restaurant_page.search("div.rating-info > div.biz-rating > span.review-count > span").count > 0
	          restaurant.photo_url = restaurant_page.search("div.photo-1 > div > a > img")[0].attributes["src"].value if restaurant_page.search("div.photo-1 > div > a > img").count > 0
	          restaurant.reservations = grab_yelp_boolean_detail("Takes Reservations", restaurant_page)
	          restaurant.good_for_children = grab_yelp_boolean_detail("Good for Children", restaurant_page)
	          restaurant.good_for_groups = grab_yelp_boolean_detail("Good for Groups", restaurant_page)
	          restaurant.take_away = grab_yelp_boolean_detail("Take Away", restaurant_page)
	          restaurant.alcohol = grab_yelp_string_detail("Alcohol", restaurant_page)
	          restaurant.ambience = grab_yelp_string_detail("Ambience", restaurant_page)
	          restaurant.noise_level = grab_yelp_noise_detail(restaurant_page)
	          restaurant.fetched_at = Time.zone.now

	          restaurant.save

	          restaurant.set_opening_periods(restaurant_page)

	          restaurant.add_tags(restaurant_page)
	        end
        end
        page_count += 1
        break if page_count == total_page_count
      end
    end
  end


  def fetch
    if yelp_id.nil?
      find_on_yelp
      sleep 2
    end
    if yelp_id.nil? == false
      agent = Mechanize.new
      agent.keep_alive = false
      agent.user_agent = "Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      restaurant_page = agent.get "http://www.yelp.com.au/biz/" + yelp_id
      if restaurant_page.search("[text()*='Claim your business page and access your']").count == 0
        self.yelp_score = restaurant_page.search("div.biz-rating > div.rating-very-large > meta").first.attributes["content"].value.to_f if restaurant_page.search("div.biz-rating > div.rating-very-large > meta").count > 0
        self.yelp_price = restaurant_page.search("div.price-category > span.bullet-after > span.price-range").text.count("$") if restaurant_page.search("div.price-category > span.bullet-after > span.price-range").count > 0
        self.yelp_review_count = restaurant_page.search("div.rating-info > div.biz-rating > span.review-count > span").text.to_i if restaurant_page.search("div.rating-info > div.biz-rating > span.review-count > span").count > 0
        self.yelp_photo_url = restaurant_page.search("div.photo-1 > div > a > img")[0].attributes["src"].value if restaurant_page.search("div.photo-1 > div > a > img").count > 0
        self.yelp_reservations = grab_yelp_boolean_detail("Takes Reservations", restaurant_page)
        self.yelp_good_for_children = grab_yelp_boolean_detail("Good for Children", restaurant_page)
        self.yelp_good_for_groups = grab_yelp_boolean_detail("Good for Groups", restaurant_page)
        self.yelp_take_away = grab_yelp_boolean_detail("Take Away", restaurant_page)
        self.yelp_alcohol = grab_yelp_string_detail("Alcohol", restaurant_page)
        self.yelp_ambience = grab_yelp_string_detail("Ambience", restaurant_page)
        self.yelp_noise_level = grab_yelp_noise_detail(restaurant_page)
      end
      sleep 2
    end
    self.yelp_last_fetched = Time.zone.now
    self.save!
  end

  def self.grab_yelp_boolean_detail(detail, restaurant_page)
    result = nil
    if (results = restaurant_page.search("dt.attribute-key[text()*='" + detail + "']")).count > 0
      result = (results[0].parent.search("dd").text.gsub(/\n/, "").strip == "Yes")
    end
    result
  end

  def self.grab_yelp_string_detail(detail, restaurant_page)
    result = nil
    if (results = restaurant_page.search("dt.attribute-key[text()*='" + detail + "']")).count > 0
      result = results[0].parent.search("dd").text.gsub(/\n/, "").strip
    end
    result
  end

  def self.grab_yelp_noise_detail(restaurant_page)
    result = nil
    if (results = restaurant_page.search("dt.attribute-key[text()*='Noise Level']")).count > 0
      text_result = results[0].parent.search("dd").text.gsub(/\n/, "").strip
      result = 0 if text_result == "Very Quiet"
      result = 1 if text_result == "Quiet"
      result = 2 if text_result == "Average"
      result = 3 if text_result == "Loud"
      result = 4 if text_result == "Very Loud"
    end
    result
  end

  def set_opening_periods(restaurant_page)
    opening_period_count = 0
    restaurant_page.search("table.hours-table > tbody > tr").each_with_index do |html, index_day|
    	day = (index_day + 1) % 7
      if html.search("td").first.text.gsub(/\n/, "").strip == "Open 24 hours"
        opening_period = self.opening_periods[opening_period_count] || self.opening_periods.build
        opening_period.opens_at = day * 24 * 60
        opening_period.closes_at = (day + 1) * 24 * 60
        opening_period.save!
        opening_period_count += 1
      else
        start_time = nil
        end_time = nil
        html.search("td > span.nowrap").map(&:text).each_with_index do |time, index|
          hours = time.scan(/[^:]+/)[0].to_i
          hours = 0 if hours == 12
          hours = hours + 12 if time[-2..-1] == "pm"
          minutes = time[-5..-4].to_i
          processed_time = hours * 60 + minutes + day * 24 * 60
          if index % 2 == 0
            start_time = processed_time
          else
            end_time = processed_time
            end_time = end_time + 24 * 60 if end_time < start_time
            opening_period = self.opening_periods[opening_period_count] || self.opening_periods.build
            puts opening_period.to_s
            opening_period.opens_at = start_time
            opening_period.closes_at = end_time
            opening_period.save!
            opening_period_count += 1
          end
        end
      end
    end
    if self.opening_periods.count > (opening_period_count + 1)
    	((opening_period_count)..(self.opening_periods.count-1)).each do |index_to_destroy|
    		self.opening_periods[index_to_destroy].destroy
    	end
    end
  end

  def opening_periods_in_text
  	return_text = ""
  	opening_periods.from_monday.each do |opening_period|
  		weekday_num = (opening_period.opens_at / (24 * 60)).floor
  		weekday = Date::DAYNAMES[weekday_num]
  		open_time = (opening_period.opens_at_24 / 60).floor.to_s + ":" + "%02d" % (opening_period.opens_at_24 % 60)
  		close_time = (opening_period.closes_at_24 / 60).floor.to_s + ":" + "%02d" % (opening_period.closes_at_24 % 60)
  		return_text += weekday + ": " + open_time + " - " + close_time + "\n"
  	end
  	return_text
  end

  def add_tags(restaurant_page)
    restaurant_page.search("span.category-str-list > a").map(&:text).each do |tag_name|
	  	if tag_name != "Restaurants"
	  		tag_name = tag_name[0..-13] if tag_name[-11..-1] == "Restaurants"
	      tag = Tag.find_or_create_by(name: tag_name)
	      new_restaurant_tag = self.restaurant_tags.find_or_create_by(tag_id: tag.id)
	    end
	  end
	end

  def load_instagram_photos(force_search = false)
    if ((self.instagram_photos_fetched_at.nil? || self.instagram_photos_fetched_at < Time.zone.now - 14.days) && (self.instagram_photos.length == 0)) || force_search
      puts "Loading photos for: " + self.name
      locations = Instagram.location_search(latitude, longitude).select{|location| location["name"].similarity_to(self.name) > 0.2}
      media = []
      locations.each do |location|
        media += Instagram.location_recent_media(location["id"]).map{|m| m["images"]}
      end
      media.each do |photo|
        instagram_photo = self.photos.from_source("Instagram").find_or_initialize_by(low_resolution_url: photo["thumbnail"]["url"])
        instagram_photo.update_attributes(:medium_resolution_url => photo["low_resolution"]["url"], :high_resolution_url => photo["standard_resolution"]["url"], source: "Instagram")
        instagram_photo.save
      end
      update_attributes(instagram_photos_fetched_at: Time.zone.now)
    end
  end

  def load_yelp_photos(force_search = false)
    if self.yelp_photos_last_fetched_at.nil? || self.yelp_photos_last_fetched_at < Time.zone.now - 90.days || force_search
      agent = Mechanize.new
      agent.keep_alive = false
      agent.user_agent = "Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      photo_page = agent.get "http://www.yelp.com.au/biz_photos/" + yelp_id
      photo_page.search(".photos-index > .photos > .photo").each do |photo|
        photo_id = photo.search("a")[0].attr("href")[-22..-1]
        yelp_photo = self.photos.from_source("Yelp").find_or_initialize_by(low_resolution_url: "http://s3-media3.fl.yelpcdn.com/bphoto/" + photo_id + "/ms.jpg")
        yelp_photo.update_attributes(:medium_resolution_url => "http://s3-media3.fl.yelpcdn.com/bphoto/" + photo_id + "/l.jpg", :high_resolution_url => "http://s3-media3.fl.yelpcdn.com/bphoto/" + photo_id + "/l.jpg", source: "Yelp")
        yelp_photo.save
      end
      self.update_attributes(yelp_photos_last_fetched_at: Time.zone.now)
    end
  end

	scope :open_now, lambda{ where("EXISTS (SELECT 1 FROM opening_periods WHERE opening_periods.openable_type = 'YelpRestaurant' and opening_periods.openable_id = yelp_restaurants.id AND opening_periods.opens_at < :current_time_plus AND opening_periods.closes_at > :current_time)", current_time_plus: (Time.zone.now.wday * 24 * 60 + (Time.zone.now.hour > 15 && Time.zone.now.hour < 20 ? 20 : Time.zone.now.hour + 1) * 60 + Time.zone.now.min), current_time: (Time.zone.now.wday * 24 * 60 + Time.zone.now.hour * 60 + Time.zone.now.min)) }

  def self.affordable
    where("price < 4")
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << (column_names + ["Urbanspoon Name", "Urbanspoon Rating"])
      near("Surry Hills NSW 2010", 2).each do |product|
        if urbanspoon_r = product.on_urbanspoon
          csv << (product.attributes.values_at(*column_names) + [ urbanspoon_r.name, urbanspoon_r.rating])
        else
          csv << (product.attributes.values_at(*column_names) + ["", ""])
        end
      end
    end
  end

end
