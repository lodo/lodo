require 'test_helper'

class Admin::AdminsControllerTest < ActionController::TestCase
  test "should get index" do
    admin = Admin.make
    sign_in :admin, admin
    get :index
    assert_response :success
    assert_not_nil assigns(:admins)
  end

  test "should get new" do
    admin = Admin.make
    sign_in :admin, admin
    get :new
    assert_response :success
  end

  test "should create admin" do
    admin = Admin.make
    sign_in :admin, admin
    new_admin = Admin.make_unsaved
    assert_difference('Admin.count') do
      post :create, :admin => { :email => "new_admin@admins.com", :password => "Secret123", :password_confirmation => "Secret123" }
    end

    assert_redirected_to admin_admin_path(assigns(:admin))
  end

  test "should show admin" do
    admin = Admin.make
    sign_in :admin, admin
    get :show, :id => admin.id
    assert_response :success
  end

  test "should get edit" do
    admin = Admin.make
    sign_in :admin, admin
    get :edit, :id => admin.id
    assert_response :success
  end

  test "should update admin" do
    admin = Admin.make
    sign_in :admin, admin
    put :update, :id => admin.id, :admin => { }
    assert_redirected_to [:admin, assigns(:admin)]
  end

  test "should destroy admin" do
    admin = Admin.make
    sign_in :admin, admin
    admin_to_delete = Admin.make
    assert_difference('Admin.count', -1) do
      delete :destroy, :id => admin_to_delete.id
    end
  
    assert_redirected_to admin_admins_path
  end
end
