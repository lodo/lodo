require 'test_helper'

class CountyTaxZonesControllerTest < ActionController::TestCase
  setup do
    @county_tax_zone = county_tax_zones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:county_tax_zones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create county_tax_zone" do
    assert_difference('CountyTaxZone.count') do
      post :create, :county_tax_zone => @county_tax_zone.attributes
    end

    assert_redirected_to county_tax_zone_path(assigns(:county_tax_zone))
  end

  test "should show county_tax_zone" do
    get :show, :id => @county_tax_zone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @county_tax_zone.to_param
    assert_response :success
  end

  test "should update county_tax_zone" do
    put :update, :id => @county_tax_zone.to_param, :county_tax_zone => @county_tax_zone.attributes
    assert_redirected_to county_tax_zone_path(assigns(:county_tax_zone))
  end

  test "should destroy county_tax_zone" do
    assert_difference('CountyTaxZone.count', -1) do
      delete :destroy, :id => @county_tax_zone.to_param
    end

    assert_redirected_to county_tax_zones_path
  end
end
