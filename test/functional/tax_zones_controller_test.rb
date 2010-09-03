require 'test_helper'

class TaxZonesControllerTest < ActionController::TestCase
  setup do
    @tax_zone = tax_zones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tax_zones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tax_zone" do
    assert_difference('TaxZone.count') do
      post :create, :tax_zone => @tax_zone.attributes
    end

    assert_redirected_to tax_zone_path(assigns(:tax_zone))
  end

  test "should show tax_zone" do
    get :show, :id => @tax_zone.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tax_zone.to_param
    assert_response :success
  end

  test "should update tax_zone" do
    put :update, :id => @tax_zone.to_param, :tax_zone => @tax_zone.attributes
    assert_redirected_to tax_zone_path(assigns(:tax_zone))
  end

  test "should destroy tax_zone" do
    assert_difference('TaxZone.count', -1) do
      delete :destroy, :id => @tax_zone.to_param
    end

    assert_redirected_to tax_zones_path
  end
end
