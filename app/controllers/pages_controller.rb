class PagesController < ApplicationController
	def home
			if params[:location]
				location = Geocoder.search(params[:location])[0]
				@lat_lng = [location.latitude.to_s, location.longitude.to_s]
			else
			  @lat_lng = cookies[:lat_lng].split("|") if cookies[:lat_lng]
			end
		  if @lat_lng
		  	params[:distance] ||= "walking"
		  	params[:open_now] ||= true
		  	params[:lat_lng] ||= @lat_lng.join("|")
		  	@search = Search.create_with_params(params)
		  	@restaurants = @search.results

		  end
	end
end
