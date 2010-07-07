
class PaycheckTemplatesController < ApplicationController
  before_filter :company_required
  before_filter :setup_form

  def setup_form
    @accounts = current_user.current_company.accounts
    @units = current_user.current_company.units
    @projects = current_user.current_company.projects
    @employees = current_user.current_company.employees
  end

  # GET /paycheck_line_templates
  # GET /paycheck_line_templates.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => [] }
    end
  end
  
  # GET /paycheck_line_templates/1
  # GET /paycheck_line_templates/1.xml
  def show
    raise "NOT IMPLEMENTED"
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck_line_template }
    end
  end
  
  # GET /paycheck_line_templates/1/edit
  def edit
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck_line_template }
    end
  end

  # DELETE /paycheck_line_templates/1
  # DELETE /paycheck_line_templates/1.xml
  def destroy
    raise "NOT IMPLEMENTED"
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
    @paycheck_line_template.destroy

    respond_to do |format|
      format.html { redirect_to(paycheck_line_templates_url) }
      format.xml  { head :ok }
    end
  end
end
