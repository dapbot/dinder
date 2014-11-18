class YelpRestaurantsController < ApplicationController
  before_action :set_yelp_restaurant, only: [:show, :edit, :update, :destroy]

  # GET /yelp_restaurants
  # GET /yelp_restaurants.json
  def index
    @yelp_restaurants = YelpRestaurant.all
    respond_to do |format|
      format.html
      format.csv { send_data YelpRestaurant.to_csv }
    end
  end

  # GET /yelp_restaurants/1
  # GET /yelp_restaurants/1.json
  def show
  end

  # GET /yelp_restaurants/new
  def new
    @yelp_restaurant = YelpRestaurant.new
  end

  # GET /yelp_restaurants/1/edit
  def edit
  end

  # POST /yelp_restaurants
  # POST /yelp_restaurants.json
  def create
    @yelp_restaurant = YelpRestaurant.new(yelp_restaurant_params)

    respond_to do |format|
      if @yelp_restaurant.save
        format.html { redirect_to @yelp_restaurant, notice: 'Yelp restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @yelp_restaurant }
      else
        format.html { render :new }
        format.json { render json: @yelp_restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yelp_restaurants/1
  # PATCH/PUT /yelp_restaurants/1.json
  def update
    respond_to do |format|
      if @yelp_restaurant.update(yelp_restaurant_params)
        format.html { redirect_to @yelp_restaurant, notice: 'Yelp restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @yelp_restaurant }
      else
        format.html { render :edit }
        format.json { render json: @yelp_restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yelp_restaurants/1
  # DELETE /yelp_restaurants/1.json
  def destroy
    @yelp_restaurant.destroy
    respond_to do |format|
      format.html { redirect_to yelp_restaurants_url, notice: 'Yelp restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yelp_restaurant
      @yelp_restaurant = YelpRestaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yelp_restaurant_params
      params[:yelp_restaurant]
    end
end
