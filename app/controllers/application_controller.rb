# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale, :login_required, :update_company
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'fd4b65ee1595df77234ee4ea6a277542'
  
  filter_parameter_logging "password"

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password


  def set_locale
    I18n.locale = session[:locale] = params[:locale] || session[:locale] || nil
  end

  def login_required
    ok = true
    #print "LALALALA", session[:user].current_company,"\n"
    
    if session[:user]
      ok &= real_user = User.find(session[:user].id) 
      ok &= real_user.login == session[:user].login
      ok &= real_user.hashed_password == session[:user].hashed_password
    else
      ok = false
    end
    
    if ok
      return true
    end

    flash[:warning]='Please login to continue'
    session[:return_to]=request.request_uri
    redirect_to :controller => "users", :action => "login"
    return false 
  rescue ActiveRecord::RecordNotFound 
    flash[:warning]='You user has been deleted'
    session[:user] = nil
    session[:user].current_company = nil
    redirect_to :controller => "users", :action => "login"
    return false 
  end

  def company_required
    if session[:user].current_company.nil?
      session[:user].current_company = session[:user].companies.first
    end    

    if not session[:user].current_company.nil?
      return true
    end

    flash[:notice]='You must have at least one company to work with'
    redirect_to :controller => "companies", :action => "index"
    return false 
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to_url(return_to)
    else
      redirect_to :controller=>'users', :action=>'welcome'
    end
  end

  def set_locale
    #I18n.locale = session[:locale] = params[:locale] || session[:locale] || nil
  end

  # FIXME!!!!!
  # Don't store stuff in session, we can't trust it
  def update_company
    session[:user].current_company = Company.find( session[:user].current_company.id)
  end

end
