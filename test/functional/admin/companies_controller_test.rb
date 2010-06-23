require 'test_helper'

class Admin::CompaniesControllerTest < ActionController::TestCase
  test "should get index" do
    admin = Admin.make
    sign_in :admin, admin
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test "should get new" do
    admin = Admin.make
    sign_in :admin, admin
    get :new
    assert_response :success
  end

  test "should create company" do
    admin = Admin.make
    sign_in :admin, admin
    assert_difference('Company.count') do
      post :create, :company => {:name => "Random LTD"}
    end

    assert_redirected_to admin_company_path(assigns(:company))
  end

  test "should show company" do
    admin = Admin.make
    sign_in :admin, admin
    company = Company.make
    get :show, :id => company.id
    assert_response :success
  end

  test "should get edit" do
    admin = Admin.make
    sign_in :admin, admin
    company = Company.make
    get :edit, :id => company.id
    assert_response :success
  end

  test "should update company" do
    admin = Admin.make
    sign_in :admin, admin
    company = Company.make
    new_name = "New company name"
    put :update, :id => company.id, :company => { :name => new_name }
    assert_redirected_to [:admin, assigns(:company)]
    assert_equal new_name, company.reload.name
  end

  test "should destroy company" do
    admin = Admin.make
    sign_in :admin, admin
    company_to_delete = Company.make
    assert_difference('Company.count', -1) do
      delete :destroy, :id => company_to_delete.id
    end
  
    assert_redirected_to admin_companies_path
  end

  test "show company w/o logging in should redirect to login page" do
    company = Company.make
    get :show, :id => company.id
    assert_redirected_to new_admin_session_path
  end

end
