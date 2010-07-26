require 'test_helper'

class PaycheckTemplatesControllerTest < ActionController::TestCase
  setup do
    log_in_as_bob
    @employee_one = Ledger.create!(:account => @company.accounts.first, :name => "Employee One", :number => "99", :credit_text => "credit", :debit_text => "debit")
    @dummy_line_attributes = {:count => "1", :rate => "750 ", :amount => "750", :employee_id => @employee_one.id, :salary_code => "abc", :payroll_tax => "1", :vacation_basis => "1", :description => "qq", :line_type => "duh", :account_id => @company.accounts.first.id, :company_id => @company.id}
    @paycheck_line_template = PaycheckLineTemplate.create!(@dummy_line_attributes)
    qq = @dummy_line_attributes
    qq.delete(:employee_id)
    @global_paycheck_line_template = PaycheckLineTemplate.create!(qq)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employees)
  end

  test "should create template" do
    @new_employee = Ledger.create!(:account => @company.accounts.first, :name => "New Employee", :number => "98", :credit_text => "credit", :debit_text => "debit")
    assert_difference('PaycheckLineTemplate.count') do
      post :create, :employee_id => @new_employee.id
    end

    assert_redirected_to paycheck_template_path(@new_employee.id)
  end

  test "should show paycheck" do
    get :show, :id => @employee_one.id
    assert_response :success
  end

end
