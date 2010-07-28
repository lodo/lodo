require 'test_helper'

class VatAccountsControllerTest < ActionController::TestCase

  setup do
    log_in_as_bob
  end

  test "should not display other companies vat accounts" do
    get :index

    assert_response :success
    assert_template :index

    not_ours = assigns(:vat_accounts).select {|va| va.company != @company}
    assert not_ours.empty?, "It seems we're listing #{not_ours.size} vat accounts which belong to another company."
  end

end
