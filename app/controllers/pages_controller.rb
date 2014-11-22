class PagesController < ApplicationController

	def dinder
		if current_user.active_dinder_search && params[:location].nil?
			redirect_to dinder_search_path(current_user.active_dinder_search)
		else
			if params[:location]
				location = Geocoder.search(params[:location])[0]
				@lat_lng = [location.latitude.to_s, location.longitude.to_s]
			else
			  @lat_lng = cookies[:lat_lng].split("|") if cookies[:lat_lng]
			end
		  if @lat_lng
		  	params[:lat_lng] ||= @lat_lng.join("|")
		  	@search = current_user.dinder_searches.build.save_with_params(params)
		  	@restaurants = @search.results
		  end
		end
	end

	def test
	end
end
