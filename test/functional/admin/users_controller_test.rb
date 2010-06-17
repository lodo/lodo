require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  test "should get index" do
    admin = Admin.make
    sign_in :admin, admin
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    admin = Admin.make
    sign_in :admin, admin
    get :new
    assert_response :success
  end

  test "should create user" do
    admin = Admin.make
    sign_in :admin, admin
    assert_difference('User.count') do
      post :create, :user => { :email => "new_user@users.com", :password => "Secret123", :password_confirmation => "Secret123" }
    end

    assert_redirected_to admin_user_path(assigns(:user))
  end

  test "should show user" do
    admin = Admin.make
    sign_in :admin, admin
    user = User.make
    get :show, :id => user.id
    assert_response :success
  end

  test "should get edit" do
    admin = Admin.make
    sign_in :admin, admin
    user = User.make
    get :edit, :id => user.id
    assert_response :success
  end

  test "should update user" do
    admin = Admin.make
    sign_in :admin, admin
    user = User.make
    put :update, :id => user.id, :user => { }
    assert_redirected_to [:admin, assigns(:user)]
  end

  test "should destroy user" do
    admin = Admin.make
    sign_in :admin, admin
    user_to_delete = User.make
    assert_difference('User.count', -1) do
      delete :destroy, :id => user_to_delete.id
    end
  
    assert_redirected_to admin_users_path
  end
end
