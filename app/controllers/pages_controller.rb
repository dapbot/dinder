class PagesController < ApplicationController
	def home
		  @lat_lng = cookies[:lat_lng].split("|") if cookies[:lat_lng]
		  if @lat_lng
		  	@restaurants = Restaurant.open_now.near(@lat_lng, 1)
		  end
	end
end
