require 'test_helper'

class YelpRestaurantsControllerTest < ActionController::TestCase
  setup do
    @yelp_restaurant = yelp_restaurants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yelp_restaurants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yelp_restaurant" do
    assert_difference('YelpRestaurant.count') do
      post :create, yelp_restaurant: {  }
    end

    assert_redirected_to yelp_restaurant_path(assigns(:yelp_restaurant))
  end

  test "should show yelp_restaurant" do
    get :show, id: @yelp_restaurant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yelp_restaurant
    assert_response :success
  end

  test "should update yelp_restaurant" do
    patch :update, id: @yelp_restaurant, yelp_restaurant: {  }
    assert_redirected_to yelp_restaurant_path(assigns(:yelp_restaurant))
  end

  test "should destroy yelp_restaurant" do
    assert_difference('YelpRestaurant.count', -1) do
      delete :destroy, id: @yelp_restaurant
    end

    assert_redirected_to yelp_restaurants_path
  end
end
