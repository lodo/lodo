class PaychecksController < ApplicationController

  include PeriodController

  before_filter :setup_form
  before_filter :employee_required, :except => [:index]
  
  def employee_required
    @employee = current_user.current_company.employees.select {|e| e.id == params[:employee_id].to_i}.first
    @paychecksemployees = current_user.current_company.employees
  end
  
  def setup_form
    @units = current_user.current_company.units
    @projects = current_user.current_company.projects
    @employees = current_user.current_company.employees
    @paychecks = period_filter(current_user.current_company.paychecks.includes(:period).includes(:employee))
    @units = current_user.current_company.units
    @projects = current_user.current_company.projects

#    @periods = current_user.current_company.periods.select {|p| p.open?}
  end

  # GET /paychecks
  # GET /paychecks.xml
  def index
#    @paychecks = Paycheck.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paychecks }
    end
  end

  # GET /paychecks/1
  # GET /paychecks/1.xml
  def show
        
    @paycheck = Paycheck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck }
    end
  end

  # GET /paychecks/new
  # GET /paychecks/new.xml
  def new
    @paycheck = Paycheck.new
    @paycheck.employee_id = @employee.id
    @employee.paycheck_line_templates.each do |line| 
      l = {}
      ["count", "rate", "amount", "unit_id", "project_id","line_type","description","account_id","payroll_tax","vacation_basis","salary_code"].each do |key|
        l[key] = line.attributes[key]
      end
      @paycheck.paycheck_lines.build l
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paycheck }
    end
  end
  
  # GET /paychecks/1/edit
  def edit
    @paycheck = Paycheck.find(params[:id])
  end

  # POST /paychecks
  # POST /paychecks.xml
  def create
    @paycheck = Paycheck.new(params[:paycheck])

    respond_to do |format|
      if @paycheck.save
        format.html { redirect_to(@paycheck, :notice => 'Paycheck was successfully created.') }
        format.xml  { render :xml => @paycheck, :status => :created, :location => @paycheck }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paycheck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paychecks/1
  # PUT /paychecks/1.xml
  def update
    @paycheck = Paycheck.find(params[:id])

    respond_to do |format|
      if @paycheck.update_attributes(params[:paycheck])
        format.html { redirect_to(@paycheck, :notice => 'Paycheck was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paychecks/1
  # DELETE /paychecks/1.xml
  def destroy
    @paycheck = Paycheck.find(params[:id])
    @paycheck.destroy

    respond_to do |format|
      format.html { redirect_to(paychecks_url) }
      format.xml  { head :ok }
    end
  end
end
