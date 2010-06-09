class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :init_auth, :only => :index

  def index
  end

  def change_current_company
    @me.current_company = Company.find(params[:current_company])
    
    if not @me.save
      print "Unable to save current company: " + @me.errors.to_json
      flash[:warning] = "Unable to save current company: " + @me.errors.to_json
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end
  
end
