class SearchesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.csv { send_data Search.to_csv }
    end
  end
end