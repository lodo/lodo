# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_locale_now, :authenticate_user!, :init_auth
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'fd4b65ee1595df77234ee4ea6a277542'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected

  def set_locale_now
    I18n.locale = session[:locale] = params[:locale] || session[:locale]
  end

  def init_auth
    company = session[:company_id]
    Authorization.current_user = current_user
    @me = current_user
    current_user.current_company = company if company
  end

  def company_required
    if current_user.current_company.nil?
      current_user.current_company = current_user.companies.first
    end    

    if not current_user.current_company.nil?
      return true
    end

    flash[:notice]='You must have at least one company to work with'
    redirect_to :controller => "companies", :action => "index"
    return false
  end

  def permission_denied
    flash[:error] = I18n.t("access_denied")
    redirect_to root_url
  end

end
