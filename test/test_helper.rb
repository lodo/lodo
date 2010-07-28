ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require File.expand_path(File.dirname(__FILE__) + "/blueprints")

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all
  
  # Add more helper methods to be used by all tests here...
  #setup { Sham.reset }
end

class ActionController::TestCase
  include Devise::TestHelpers


  def log_in_as_bob
    @user = User.find_by_email("bob@bobsdomain.com")
    @company = @user.assignments.select {|a| a.role.name == "accountant"}.map {|a| a.company}.first
    @user.current_company = @company
    @user.save!
    sign_in :user, @user
  end
end

