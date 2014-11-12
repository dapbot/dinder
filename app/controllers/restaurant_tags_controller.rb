class RestaurantTagsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.csv { send_data RestaurantTag.to_csv }
    end
  end
end