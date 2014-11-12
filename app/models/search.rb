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

class Search < ActiveRecord::Base
	def self.create_with_params(params)
		search = self.new
		search.open_now = params[:open_now]
		search.lat_lng = params[:lat_lng]
		search.cheaper_than = params[:cheaper_than]
		search.fancier_than = params[:fancier_than]
		search.not_cuisines = params.select {|key, value| key.to_s.starts_with?("not_c_")}.map{|key, value| key.to_s[6..-1].gsub(/_/, " ")}
		search.save
		search
	end

	def results
    results = Restaurant.where(nil)
    results = results.near(lat_lng.split("|"), 2)
    results = results.open_now if open_now
    results = results.where("price < ?", cheaper_than) if !cheaper_than.nil?
    results = results.where("price > ?", fancier_than) if !fancier_than.nil?
    results = results.where("restaurants.id NOT IN (SELECT restaurant_id FROM restaurant_tags WHERE tag_id IN (SELECT id FROM tags WHERE lower(name) IN (?)))", not_cuisines) if not_cuisines.count > 0
    results = results.reorder("urbanspoon_ranking ASC").limit(10).sort_by {|r| r.distance_to( lat_lng.split("|") )}
  end

  def params
  	params = {}
  	params[:open_now] = open_now
  	params[:lat_lng] = lat_lng
  	params[:cheaper_than] = cheaper_than
  	params[:fancier_than] = fancier_than
  	not_cuisines.each do |not_cuisine|
  		params[("not_c_" + not_cuisine.underscore).to_sym] = true
  	end
  	params
  end
end
