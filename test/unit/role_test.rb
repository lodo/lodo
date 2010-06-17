require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  test "if to_sym works..." do
    r = Role.make(:name => "meh")
    assert r.to_sym == :meh
  end
end
