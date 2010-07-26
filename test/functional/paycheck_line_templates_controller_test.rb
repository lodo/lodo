require 'test_helper'

class PaycheckLineTemplatesControllerTest < ActionController::TestCase
  setup do
    log_in_as_bob
    @employee_one = Ledger.create!(:account => @company.accounts.first, :name => "Employee One", :number => "99", :credit_text => "credit", :debit_text => "debit")
    @dummy_line_attributes = {:count => "1", :rate => "750 ", :amount => "750", :employee_id => @employee_one.id, :salary_code => "abc", :payroll_tax => "1", :vacation_basis => "1", :description => "qq", :line_type => "duh", :account_id => @company.accounts.first.id, :company_id => @company.id}
    @paycheck_line_template = PaycheckLineTemplate.create!(@dummy_line_attributes)
  end

  test "should get new" do
    get :new, :employee_id => @employee_one.id
    assert_response :success
  end

  test "should create paycheck_line_template" do
    assert_difference('PaycheckLineTemplate.count') do
      post :create, :paycheck_line_template => @dummy_line_attributes
    end

    assert_redirected_to paycheck_template_path(@employee_one.id)
  end

  test "should create global template line" do
    qq = @dummy_line_attributes.clone
    qq.delete(:employee_id)
    assert_difference('PaycheckLineTemplate.count') do
      post :create, :paycheck_line_template => qq
    end

    assert_redirected_to paycheck_template_path(:global)
  end

  test "should get edit" do
    get :edit, :id => @paycheck_line_template.to_param
    assert_response :success
  end

  test "should update paycheck_line_template" do
    put :update, :id => @paycheck_line_template.to_param, :paycheck_line_template => @paycheck_line_template.attributes
    assert_redirected_to paycheck_template_path(@employee_one.id)
  end

  test "should destroy paycheck_line_template" do
    @line = PaycheckLineTemplate.create!(@dummy_line_attributes)
    assert_difference('PaycheckLineTemplate.count', -1) do
      delete :destroy, :id => @line.to_param
    end

    assert_redirected_to paycheck_template_path(@employee_one.id)
  end
end
