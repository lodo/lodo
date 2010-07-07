class PaychecksController < ApplicationController

  before_filter :company_required
  before_filter :setup_form
  before_filter :employee_required, :except => [:index]
  
  def employee_required
    @employee = current_user.current_company.employees.find(params[:employee_id])
    @paychecksemployees = current_user.current_company.employees
  end
  
  def setup_form
    @units = current_user.current_company.units
    @projects = current_user.current_company.projects
    @employees = current_user.current_company.employees
    @paychecks = current_user.current_company.paychecks
  end

  # GET /paychecks
  # GET /paychecks.xml
  def index
    @paychecks = Paycheck.all

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
