require 'test_helper'

class OrderItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_item" do
    assert_difference('OrderItem.count') do
      post :create, :order_item => { }
    end

    assert_redirected_to order_item_path(assigns(:order_item))
  end

  test "should show order_item" do
    get :show, :id => order_items(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => order_items(:one).id
    assert_response :success
  end

  test "should update order_item" do
    put :update, :id => order_items(:one).id, :order_item => { }
    assert_redirected_to order_item_path(assigns(:order_item))
  end

  test "should destroy order_item" do
    assert_difference('OrderItem.count', -1) do
      delete :destroy, :id => order_items(:one).id
    end

    assert_redirected_to order_items_path
  end
end
