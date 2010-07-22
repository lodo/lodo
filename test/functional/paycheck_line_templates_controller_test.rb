require 'test_helper'

class PaycheckLineTemplatesControllerTest < ActionController::TestCase
  setup do
    @bob = User.find_by_email("bob@bobsdomain.com")
    @company = @bob.assignments.select {|a| a.role.name == "accountant"}.map {|a| a.company}.first
    @employee_one = Ledger.create!(:account => @company.accounts.first, :name => "Employee One", :number => "99", :credit_text => "credit", :debit_text => "debit")
    @dummy_line_attributes = {:count => "1", :rate => "750 ", :amount => "750", :employee_id => @employee_one.id, :salary_code => "abc", :payroll_tax => "1", :vacation_basis => "1", :description => "qq", :line_type => "duh", :account_id => @company.accounts.first.id}
    sign_in :user, @bob
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paycheck_line_templates)
  end

  test "should get new" do
    get :new, :employee_id => @employee_one.id
    assert_response :success
  end

  test "should create paycheck_line_template" do
    assert_difference('PaycheckLineTemplate.count') do
      post :create, :paycheck_line_template => @dummy_line_attributes
    end

    assert_redirected_to paycheck_line_template_path(assigns(:paycheck_line_template))
  end

  test "should show paycheck_line_template" do
    get :show, :id => @paycheck_line_template.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paycheck_line_template.to_param
    assert_response :success
  end

  test "should update paycheck_line_template" do
    put :update, :id => @paycheck_line_template.to_param, :paycheck_line_template => @paycheck_line_template.attributes
    assert_redirected_to paycheck_line_template_path(assigns(:paycheck_line_template))
  end

  test "should destroy paycheck_line_template" do
    @line = PaycheckLineTemplate.create!(@dummy_line_attributes)
    assert_difference('PaycheckLineTemplate.count', -1) do
      delete :destroy, :id => @line.to_param
    end

    assert_redirected_to paycheck_line_templates_path
  end
end
