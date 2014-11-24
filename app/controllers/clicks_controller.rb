class ClicksController < ApplicationController

  # GET /clicks
  # GET /clicks.json
  def index
    respond_to do |format|
      format.html
      format.csv { send_data Click.to_csv }
    end
  end

  # POST /clicks
  # POST /clicks.json
  def create
    @click = Click.new(click_params)

    respond_to do |format|
      if @click.save
        format.html { redirect_to @click, notice: 'Click was successfully created.' }
        format.json { render json: {status: "ok"}, status: :ok }
      else
        format.html { render :new }
        format.json { render json: {status: "error"}, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def click_params
      params.require(:click).permit(:yelp_restaurant_id, :purpose, :dinder_search_id).merge({user_id: current_user.id})
    end
end
