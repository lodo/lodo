require 'test_helper'

class JournalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:journals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create journal" do
    assert_difference('Journal.count') do
      post :create, :journal => { }
    end

    assert_redirected_to journal_path(assigns(:journal))
  end

  test "should show journal" do
    get :show, :id => journals(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => journals(:one).id
    assert_response :success
  end

  test "should update journal" do
    put :update, :id => journals(:one).id, :journal => { }
    assert_redirected_to journal_path(assigns(:journal))
  end

  test "should destroy journal" do
    assert_difference('Journal.count', -1) do
      delete :destroy, :id => journals(:one).id
    end

    assert_redirected_to journals_path
  end
end
