require 'test_helper'

class VATAccountsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vat_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vat_account" do
    assert_difference('VATAccount.count') do
      post :create, :vat_account => { }
    end

    assert_redirected_to vat_account_path(assigns(:vat_account))
  end

  test "should show vat_account" do
    get :show, :id => vat_accounts(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => vat_accounts(:one).id
    assert_response :success
  end

  test "should update vat_account" do
    put :update, :id => vat_accounts(:one).id, :vat_account => { }
    assert_redirected_to vat_account_path(assigns(:vat_account))
  end

  test "should destroy vat_account" do
    assert_difference('VATAccount.count', -1) do
      delete :destroy, :id => vat_accounts(:one).id
    end

    assert_redirected_to vat_accounts_path
  end
end
