require 'test_helper'

class BillItemsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bill_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bill_item" do
    assert_difference('BillItem.count') do
      post :create, :bill_item => { }
    end

    assert_redirected_to bill_item_path(assigns(:bill_item))
  end

  test "should show bill_item" do
    get :show, :id => bill_items(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bill_items(:one).id
    assert_response :success
  end

  test "should update bill_item" do
    put :update, :id => bill_items(:one).id, :bill_item => { }
    assert_redirected_to bill_item_path(assigns(:bill_item))
  end

  test "should destroy bill_item" do
    assert_difference('BillItem.count', -1) do
      delete :destroy, :id => bill_items(:one).id
    end

    assert_redirected_to bill_items_path
  end
end
