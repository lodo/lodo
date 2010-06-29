require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  test "should fail when accessing company you have no permissions for" do
    user = User.find_by_email("bob@bobsdomain.com")
    company = Company.make
    user.current_company = company
    user.save!
    sign_in :user, user

    get :index
    assert_redirected_to root_path
    assert_equal "Beklager, du mangler tilgang til denne siden.", flash[:error]
  end

  test "should display account listing" do
    user = User.find_by_email("bob@bobsdomain.com")
    user.current_company = user.assignments.where("roles.name = 'accountant'").first.company
    user.save!
    sign_in :user, user

    get :index
    assert_response :success
    assert_template :index
  end

  test "should display account" do
    user = User.find_by_email("bob@bobsdomain.com")
    user.current_company = user.companies.first
    user.save!
    sign_in :user, user

    get :show, :id => user.current_company.accounts.first
    assert_response :success
    assert_template :show
  end

end
