# Checks if user has permission to access administration
class Admin::BaseController < ApplicationController
  skip_before_filter :authenticate_user!, :init_auth
  before_filter :authenticate_admin!, :init_admin_auth


  # shouldn't be neccessary as we only have one admin level
  # filter_access_to :all
  
  protected

  def init_admin_auth
    Authorization.current_user = current_admin
  end

end
