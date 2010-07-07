require 'test_helper'

class PaychecksControllerTest < ActionController::TestCase
  setup do
    @paycheck = paychecks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paychecks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paycheck" do
    assert_difference('Paycheck.count') do
      post :create, :paycheck => @paycheck.attributes
    end

    assert_redirected_to paycheck_path(assigns(:paycheck))
  end

  test "should show paycheck" do
    get :show, :id => @paycheck.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paycheck.to_param
    assert_response :success
  end

  test "should update paycheck" do
    put :update, :id => @paycheck.to_param, :paycheck => @paycheck.attributes
    assert_redirected_to paycheck_path(assigns(:paycheck))
  end

  test "should destroy paycheck" do
    assert_difference('Paycheck.count', -1) do
      delete :destroy, :id => @paycheck.to_param
    end

    assert_redirected_to paychecks_path
  end
end
