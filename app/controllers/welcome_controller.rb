class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, :init_auth, :only => :index
  skip_before_filter :company_required

  def index
  end

  def current_company
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
