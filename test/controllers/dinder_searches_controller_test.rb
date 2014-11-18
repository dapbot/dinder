require 'test_helper'

class DinderSearchesControllerTest < ActionController::TestCase
  setup do
    @dinder_search = dinder_searches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dinder_searches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dinder_search" do
    assert_difference('DinderSearch.count') do
      post :create, dinder_search: {  }
    end

    assert_redirected_to dinder_search_path(assigns(:dinder_search))
  end

  test "should show dinder_search" do
    get :show, id: @dinder_search
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dinder_search
    assert_response :success
  end

  test "should update dinder_search" do
    patch :update, id: @dinder_search, dinder_search: {  }
    assert_redirected_to dinder_search_path(assigns(:dinder_search))
  end

  test "should destroy dinder_search" do
    assert_difference('DinderSearch.count', -1) do
      delete :destroy, id: @dinder_search
    end

    assert_redirected_to dinder_searches_path
  end
end
