class DinderSearchesController < ApplicationController
  before_action :set_dinder_search, only: [:show, :edit, :update, :destroy, :add_no, :shortlist, :shortlistings]

  # GET /dinder_searches
  # GET /dinder_searches.json
  def index
    @dinder_searches = DinderSearch.all
  end

  # GET /dinder_searches/1
  # GET /dinder_searches/1.json
  def show
    redirect_to root_path if @dinder_search.user != current_user
    if params[:location]
      location = Geocoder.search(params[:location])[0]
      @lat_lng = [location.latitude.to_s, location.longitude.to_s]
    else
      @lat_lng = cookies[:lat_lng].split("|") if cookies[:lat_lng]
    end
    if @lat_lng
      params[:lat_lng] ||= @lat_lng.join("|")
      @search = @dinder_search
      @search.touch
      @restaurants = @search.results
    end
    render '/pages/dinder'
  end

  # GET /dinder_searches/new
  def new
    @dinder_search = DinderSearch.new
  end

  # GET /dinder_searches/1/edit
  def edit
  end

  # POST /dinder_searches
  # POST /dinder_searches.json
  def create
    @dinder_search = DinderSearch.new(dinder_search_params)

    respond_to do |format|
      if @dinder_search.save
        format.html { redirect_to @dinder_search, notice: 'Dinder search was successfully created.' }
        format.json { render :show, status: :created, location: @dinder_search }
      else
        format.html { render :new }
        format.json { render json: @dinder_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dinder_searches/1
  # PATCH/PUT /dinder_searches/1.json
  def update
    respond_to do |format|
      if @dinder_search.update(dinder_search_params)
        format.html { redirect_to @dinder_search, notice: 'Dinder search was successfully updated.' }
        format.json { render :show, status: :ok, location: @dinder_search }
      else
        format.html { render :edit }
        format.json { render json: @dinder_search.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_no
    respond_to do |format|
      if @dinder_search.add_no(params[:restaurant_id])
        format.html { redirect_to @dinder_search, notice: 'Dinder search was successfully updated.' }
        format.json { render json: {status: "ok"}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: {status: "error"}, status: :unprocessable_entity }
      end
    end    
  end

  def shortlist
    respond_to do |format|
      if @dinder_search.shortlist(params[:restaurant_id])
        format.html { redirect_to @dinder_search, notice: 'Dinder search was successfully updated.' }
        format.json { render json: {status: "ok"}, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: {status: "error"}, status: :unprocessable_entity }
      end
    end    
  end

  def shortlistings
    @search = @dinder_search
    @lat_lng = cookies[:lat_lng] ? cookies[:lat_lng].split("|") : @dinder_search.lat_lng.split("|")
    @restaurants = @search.shortlisted_restaurants(@lat_lng)
  end

  # DELETE /dinder_searches/1
  # DELETE /dinder_searches/1.json
  def destroy
    @dinder_search.destroy
    respond_to do |format|
      format.html { redirect_to dinder_searches_url, notice: 'Dinder search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dinder_search
      @dinder_search = DinderSearch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dinder_search_params
      params.require(:dinder_search).permit(:add_no)
    end
end
