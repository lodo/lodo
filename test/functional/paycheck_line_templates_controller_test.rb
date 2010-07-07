require 'test_helper'

class PaycheckLineTemplatesControllerTest < ActionController::TestCase
  setup do
    @paycheck_line_template = paycheck_line_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paycheck_line_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paycheck_line_template" do
    assert_difference('PaycheckLineTemplate.count') do
      post :create, :paycheck_line_template => @paycheck_line_template.attributes
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
    assert_difference('PaycheckLineTemplate.count', -1) do
      delete :destroy, :id => @paycheck_line_template.to_param
    end

    assert_redirected_to paycheck_line_templates_path
  end
end
