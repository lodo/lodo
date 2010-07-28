require 'test_helper'

class PaychecksControllerTest < ActionController::TestCase
  setup do
    log_in_as_bob
    @employee_one = Ledger.create!(:account => @company.accounts.where(:number => '2930').first, :name => "Employee One", :number => "99", :credit_text => "credit", :debit_text => "debit")
    @dummy_line_attributes = {:count => "1", :rate => "750 ", :amount => "750", :employee_id => @employee_one.id, :salary_code => "abc", :payroll_tax => "1", :vacation_basis => "1", :description => "qq", :line_type => "duh", :account_id => @company.accounts.first.id, :company_id => @company.id}
    @paycheck_line_template = PaycheckLineTemplate.create!(@dummy_line_attributes)
    @paycheck = Paycheck.create!({"period_id"=>@company.periods.first.id, "employee_id"=>@employee_one.id, "paycheck_lines_attributes"=>{"0"=>{"line_type"=>"0", "description"=>"Loenn", "count"=>"150.0", "rate"=>"300.0", "amount"=>"45000.0", "account_id"=>@company.accounts.first.id, "unit_id"=>@company.units.first.id, "payroll_tax"=>"true", "vacation_basis"=>"true", "salary_code"=>"88a"}, "1"=>{"line_type"=>"2", "description"=>"Info", "count"=>"0.0", "rate"=>"345.0", "amount"=>"0.0", "account_id"=>"", "payroll_tax"=>"false", "vacation_basis"=>"false", "salary_code"=>"14b"}}})
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paychecks)
  end

  test "should get new" do
    get :new, :employee_id => @employee_one.id
    assert_response :success
  end

  test "should create paycheck" do
    assert_difference('Paycheck.count') do
      post :create, {:paycheck => {"period_id"=>@company.periods.first.id, "employee_id"=>@employee_one.id, "paycheck_lines_attributes"=>{"0"=>{"line_type"=>"0", "description"=>"Loenn", "count"=>"150.0", "rate"=>"300.0", "amount"=>"45000.0", "account_id"=>@company.accounts.first.id, "unit_id"=>@company.units.first.id, "payroll_tax"=>"true", "vacation_basis"=>"true", "salary_code"=>"88a"}, "1"=>{"line_type"=>"2", "description"=>"Info", "count"=>"0.0", "rate"=>"345.0", "amount"=>"0.0", "account_id"=>"", "payroll_tax"=>"false", "vacation_basis"=>"false", "salary_code"=>"14b"}}}}
    end

    assert_redirected_to paycheck_path(assigns(:paycheck))
  end

  test "should show paycheck" do
    get :show, :id => @paycheck.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paycheck.to_param
    assert_response :success
  end

  test "should update paycheck" do
    put :update, :id => @paycheck.to_param, :paycheck => @paycheck.attributes
    assert_redirected_to paycheck_path(assigns(:paycheck))
  end

  test "should destroy paycheck" do
    assert_difference('Paycheck.count', -1) do
      delete :destroy, :id => @paycheck.to_param
    end

    assert_redirected_to paychecks_path
  end
end
