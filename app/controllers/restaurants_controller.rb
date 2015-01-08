class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = Restaurant.where(nil)
    @restaurants = @restaurants.where(suburb: params[:search_suburb]) if params[:search_suburb].blank? == false
    @restaurants = @restaurants.order("dinder_score DESC NULLS LAST").paginate(:per_page => 20, :page => params[:page])
    # @sort_column = sort_column
    # @sort_direction = sort_direction

    respond_to do |format|
      format.html
      format.csv { send_data Restaurant.to_csv }
    end
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      set_ignore_photos
      if @restaurant.update_attributes(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def set_ignore_photos
      (params[:ignore_photos] || []).each do |photo_id|
        Photo.find(photo_id.to_i).update_attributes(ignore: true)
      end
      Photo.where("ignore = true").each do |photo|
        photo.update_attributes(ignore: false) if params[:ignore_photos].blank? || params[:ignore_photos].include?(photo.id.to_s) == false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :suburb, :address, :latitude, :longitude, :dinder_score, :price, :phone_number, :website, :photo_1_id, :photo_2_id, :photo_3_id, :ignore_photos)
    end

    def sort_column  
      params[:sort] || "id"  
    end  
      
    def sort_direction  
      params[:direction] || "asc"  
    end  
end
