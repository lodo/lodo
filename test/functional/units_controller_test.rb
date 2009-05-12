require 'test_helper'

class UnitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit" do
    assert_difference('Unit.count') do
      post :create, :unit => { }
    end

    assert_redirected_to unit_path(assigns(:unit))
  end

  test "should show unit" do
    get :show, :id => units(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => units(:one).to_param
    assert_response :success
  end

  test "should update unit" do
    put :update, :id => units(:one).to_param, :unit => { }
    assert_redirected_to unit_path(assigns(:unit))
  end

  test "should destroy unit" do
    assert_difference('Unit.count', -1) do
      delete :destroy, :id => units(:one).to_param
    end

    assert_redirected_to units_path
  end
end
