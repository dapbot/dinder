class PagesController < ApplicationController
	def home
			if params[:location]
				location = Geocoder.search(params[:location])[0]
				@lat_lng = [location.latitude.to_s, location.longitude.to_s]
			else
			  @lat_lng = cookies[:lat_lng].split("|") if cookies[:lat_lng]
			end
		  if @lat_lng
		  	@restaurants = Restaurant.open_now.near(@lat_lng, 2)
		  end
	end
end
