class OpeningPeriodsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.csv { send_data OpeningPeriod.to_csv }
    end
  end
end