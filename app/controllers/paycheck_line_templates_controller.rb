class PaycheckLineTemplatesController < ApplicationController
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
    raise "asdlfkjsldjkfee"
    @paycheck_line_templates = PaycheckLineTemplate.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paycheck_line_templates }
    end
  end
  
  # GET /paycheck_line_templates/1
  # GET /paycheck_line_templates/1.xml
  def show
    raise "dslkfjasldfjas"
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
    if params[:employee_id]
      @employee = Ledger.find(params[:employee_id])
      @paycheck_line_template.employee = @employee
    else
      
    end

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
    @paycheck_line_template.company = current_user.current_company
    
    respond_to do |format|
      if @paycheck_line_template.save
        id = @paycheck_line_template.maybe_employee_id
        format.html do
          redirect_to(paycheck_template_url(id), 
                      :notice => t('paycheck_line_templates.created')) 
          end
        
        format.xml do 
          render :xml => @paycheck_line_template, 
          :status => :created, :location => @paycheck_line_template 
        end
      else
        format.html do
          render :action => "new" 
        end
        format.xml do
          render :xml => @paycheck_line_template.errors, 
          :status => :unprocessable_entity 
        end
      end
    end
  end

  # PUT /paycheck_line_templates/1
  # PUT /paycheck_line_templates/1.xml
  def update
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])

    respond_to do |format|
      if @paycheck_line_template.update_attributes(params[:paycheck_line_template])
        id = @paycheck_line_template.maybe_employee_id
        format.html { redirect_to(paycheck_template_url(id), 
                                  :notice => t('paycheck_line_templates.saved')) }

        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck_line_template.errors, :status => :unprocessable_entity }      end
    end
  end

  # DELETE /paycheck_line_templates/1
  # DELETE /paycheck_line_templates/1.xml
  def destroy
    @paycheck_line_template = PaycheckLineTemplate.find(params[:id])
    id = @paycheck_line_template.maybe_employee_id
    @paycheck_line_template.destroy

    respond_to do |format|
      format.html { redirect_to(paycheck_template_url(id), 
                                  :notice => t('paycheck_line_templates.destroyed')) }
      format.xml  { head :ok }
    end
  end
end
