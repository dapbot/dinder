class TagsController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.csv { send_data Tag.to_csv }
    end
  end
end