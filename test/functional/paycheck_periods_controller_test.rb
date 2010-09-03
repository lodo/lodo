require 'test_helper'

class PaycheckPeriodsControllerTest < ActionController::TestCase
  setup do
    @paycheck_period = paycheck_periods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paycheck_periods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paycheck_period" do
    assert_difference('PaycheckPeriod.count') do
      post :create, :paycheck_period => @paycheck_period.attributes
    end

    assert_redirected_to paycheck_period_path(assigns(:paycheck_period))
  end

  test "should show paycheck_period" do
    get :show, :id => @paycheck_period.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paycheck_period.to_param
    assert_response :success
  end

  test "should update paycheck_period" do
    put :update, :id => @paycheck_period.to_param, :paycheck_period => @paycheck_period.attributes
    assert_redirected_to paycheck_period_path(assigns(:paycheck_period))
  end

  test "should destroy paycheck_period" do
    assert_difference('PaycheckPeriod.count', -1) do
      delete :destroy, :id => @paycheck_period.to_param
    end

    assert_redirected_to paycheck_periods_path
  end
end
