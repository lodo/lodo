require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  setup do
    @county = counties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create county" do
    assert_difference('County.count') do
      post :create, :county => @county.attributes
    end

    assert_redirected_to county_path(assigns(:county))
  end

  test "should show county" do
    get :show, :id => @county.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @county.to_param
    assert_response :success
  end

  test "should update county" do
    put :update, :id => @county.to_param, :county => @county.attributes
    assert_redirected_to county_path(assigns(:county))
  end

  test "should destroy county" do
    assert_difference('County.count', -1) do
      delete :destroy, :id => @county.to_param
    end

    assert_redirected_to counties_path
  end
end
