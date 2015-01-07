class RestaurantsController < ApplicationController

  # GET /restaurants
  # GET /restaurants.json
  def index
    respond_to do |format|
      format.html
      format.csv { send_data Restaurant.to_csv }
    end
  end
end