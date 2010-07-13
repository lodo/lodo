require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  test "if the welcome page works" do
    get :index
    assert_response :success
  end

  test "changing the current user" do
    company1 = Company.make
    user = User.make
    role = Role.find_by_name("accountant")
    Assignment.create(:company => company1, :role => role, :user => user)
    user.current_company = company1
    user.save!
    sign_in :user, user
    
    company2 = Company.make
    Assignment.create(:company => company2, :role => role, :user => user)
    @request.env["HTTP_REFERER"] = root_path
    put :current_company, :current_company => company2.id

    assert_redirected_to root_path
    assert_equal company2, user.reload.current_company
  end

end
