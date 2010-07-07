class PaycheckLineTemplatesController < ApplicationController
  before_filter :company_required
  before_filter :setup_form

  def setup_form
    @accounts = current_user.current_company.accounts
    @units = current_user.current_company.units
    @projects = current_user.current_company.projects
    empolyee_account_id = 20
    @employees = Account.find(empolyee_account_id).ledgers
  end

  # GET /paycheck_line_templates
  # GET /paycheck_line_templates.xml
  def index
    @paycheck_line_templates = PaycheckLineTemplate.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paycheck_line_templates }
    end
  end
  
  # GET /paycheck_line_templates/1
  # GET /paycheck_line_templates/1.xml
  def show
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck_line_template }
    end
  end
  
  # GET /paycheck_line_templates/new
  # GET /paycheck_line_templates/new.xml
  def new
    @paycheck_line_template = PaycheckLineTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paycheck_line_template }
    end
  end

  # GET /paycheck_line_templates/1/edit
  def edit
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
  end

  # POST /paycheck_line_templates
  # POST /paycheck_line_templates.xml
  def create
    @paycheck_line_template = PaycheckLineTemplate.new(params[:paycheck_line_template])

    respond_to do |format|
      if @paycheck_line_template.save
        format.html { redirect_to(@paycheck_line_template, :notice => 'Paycheck line template was successfully created.') }
        format.xml  { render :xml => @paycheck_line_template, :status => :created, :location => @paycheck_line_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paycheck_line_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paycheck_line_templates/1
  # PUT /paycheck_line_templates/1.xml
  def update
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])

    respond_to do |format|
      if @paycheck_line_template.update_attributes(params[:paycheck_line_template])
        format.html { redirect_to(@paycheck_line_template, :notice => 'Paycheck line template was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck_line_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paycheck_line_templates/1
  # DELETE /paycheck_line_templates/1.xml
  def destroy
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
    @paycheck_line_template.destroy

    respond_to do |format|
      format.html { redirect_to(paycheck_line_templates_url) }
      format.xml  { head :ok }
    end
  end
end
