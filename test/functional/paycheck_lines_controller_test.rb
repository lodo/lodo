require 'test_helper'

class PaycheckLinesControllerTest < ActionController::TestCase
  setup do
    @paycheck_line = paycheck_lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paycheck_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paycheck_line" do
    assert_difference('PaycheckLine.count') do
      post :create, :paycheck_line => @paycheck_line.attributes
    end

    assert_redirected_to paycheck_line_path(assigns(:paycheck_line))
  end

  test "should show paycheck_line" do
    get :show, :id => @paycheck_line.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paycheck_line.to_param
    assert_response :success
  end

  test "should update paycheck_line" do
    put :update, :id => @paycheck_line.to_param, :paycheck_line => @paycheck_line.attributes
    assert_redirected_to paycheck_line_path(assigns(:paycheck_line))
  end

  test "should destroy paycheck_line" do
    assert_difference('PaycheckLine.count', -1) do
      delete :destroy, :id => @paycheck_line.to_param
    end

    assert_redirected_to paycheck_lines_path
  end
end
