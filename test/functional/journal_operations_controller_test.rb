require 'test_helper'

class JournalOperationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:journal_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create journal_operation" do
    assert_difference('JournalOperation.count') do
      post :create, :journal_operation => { }
    end

    assert_redirected_to journal_operation_path(assigns(:journal_operation))
  end

  test "should show journal_operation" do
    get :show, :id => journal_operations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => journal_operations(:one).id
    assert_response :success
  end

  test "should update journal_operation" do
    put :update, :id => journal_operations(:one).id, :journal_operation => { }
    assert_redirected_to journal_operation_path(assigns(:journal_operation))
  end

  test "should destroy journal_operation" do
    assert_difference('JournalOperation.count', -1) do
      delete :destroy, :id => journal_operations(:one).id
    end

    assert_redirected_to journal_operations_path
  end
end
