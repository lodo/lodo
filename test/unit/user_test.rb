require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "ensure we see the proper roles" do
    c1 = Company.make
    dummy_company = Company.make
    u = User.make(:current_company => c1)
    r1 = Role.make(:name => "test_role")
    r2 = Role.make(:name => "testrole_2")
    dummy_role = Role.make(:name => "dummy")
    Assignment.create!(:user => u, :company => c1, :role => r1)
    Assignment.create!(:user => u, :company => c1, :role => r2)
    Assignment.create!(:user => u, :company => dummy_company, :role => dummy_role)

    u.reload
    assert_equal "test_role::testrole_2", u.role_symbols.sort_by(&:to_s).join("::")
  end

end

