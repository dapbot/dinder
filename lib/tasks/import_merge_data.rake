desc "Importing Urbanspoon and Yelp merge data"
task :import_merge_data => :environment do

  require 'csv'

  puts "Destroying existing database"
  Restaurant.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!('restaurants')

  puts "Loading Merge data"
  merge_csv_text = File.open("#{Rails.root}/restaurants_US_merge.csv", "r:ISO-8859-1")
  merge_csv = CSV.parse(merge_csv_text, :headers => true)

  puts "Creating matched restaurants"
  merge_csv.each do |row|
    if row["yelp_match_id"] != "NA"
      restaurant = Restaurant.create
      YelpRestaurant.find_by_id(row["yelp_match_id"].to_i).update_attributes(restaurant_id: restaurant.id)
      UrbanspoonRestaurant.find_by_id(row["id"].to_i).update_attributes(restaurant_id: restaurant.id)
    end
  end

  puts "Loading duplicates data"
  us_duplicates = {}
  yelp_duplicates = {}

  us_duplicates_csv_text = File.open("#{Rails.root}/duplicates_US.csv", "r:ISO-8859-1")
  us_duplicates_csv = CSV.parse(us_duplicates_csv_text, :headers => true)
  us_duplicates_csv.each do |row|
    us_duplicates[row["id1"].to_i] = row["id2"].to_i
  end

  yelp_duplicates_csv_text = File.open("#{Rails.root}/duplicates_yelp.csv", "r:ISO-8859-1")
  yelp_duplicates_csv = CSV.parse(yelp_duplicates_csv_text, :headers => true)
  yelp_duplicates_csv.each do |row|
    yelp_duplicates[row["id1"].to_i] = row["id2"].to_i
  end

  us_duplicates = us_duplicates.to_a
  yelp_duplicates = yelp_duplicates.to_a

  puts "Creating unmatched Urbanspoon restaurants"
  UrbanspoonRestaurant.where("restaurant_id is null").each do |us_restaurant|
    duplicate_ids = (us_duplicates.select{|pair| pair[0] == us_restaurant.id or pair[1] == us_restaurant.id}.flatten - [us_restaurant.id])
    duplicate_restaurant_id = nil
    duplicate_ids.each do |duplicate_id|
      if (rest_id = UrbanspoonRestaurant.find(duplicate_id).restaurant_id).nil? == false
        duplicate_restaurant_id = rest_id
      end
    end
    if duplicate_restaurant_id.nil?
      restaurant = Restaurant.create
    else
      restaurant = Restaurant.find(duplicate_restaurant_id)
    end
    us_restaurant.update_attributes(restaurant_id: restaurant.id)
  end

  puts "Creating unmatched Yelp restaurants"
  YelpRestaurant.where("restaurant_id is null").each do |yelp_restaurant|
    duplicate_ids = (yelp_duplicates.select{|pair| pair[0] == yelp_restaurant.id or pair[1] == yelp_restaurant.id}.flatten - [yelp_restaurant.id])
    duplicate_restaurant_id = nil
    duplicate_ids.each do |duplicate_id|
      if (rest_id = YelpRestaurant.find(duplicate_id).restaurant_id).nil? == false
        duplicate_restaurant_id = rest_id
      end
    end
    if duplicate_restaurant_id.nil?
      restaurant = Restaurant.create
    else
      restaurant = Restaurant.find(duplicate_restaurant_id)
    end
    yelp_restaurant.update_attributes(restaurant_id: restaurant.id)
  end

  puts "Populating data"
  Restaurant.all.each do |restaurant|
    puts "Populating Restaurant ID = " + restaurant.id.to_s
    restaurant.populate_data
  end

end


desc "Importing tag data"
task :import_tag_data => :environment do
  puts "Loading tag data file"
  tags_csv_text = File.open("#{Rails.root}/tags2.csv", "r:ISO-8859-1")
  tags_csv = CSV.parse(tags_csv_text, :headers => true)

  puts "Updating tags"
  tags_csv.each do |row|
    tag = Tag.find_by_id(row["id"].to_i)
    tag.clean_name = row["rename"]
    tag.tag_type = row["tag_type"]
    tag.ignore = row["tag_type"] == "Delete"
    tag.save
  end
end