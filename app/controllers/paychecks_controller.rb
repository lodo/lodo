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

  def period_total_type line
    return 0.0
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
    make_journal @paycheck

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
    @paycheck.paycheck_period_id = user_company_property("paycheck.paycheck_period_id", nil)
    @paycheck.period_id = user_company_property("paycheck.period_id", nil)
    
    @employee.paycheck_line_templates.each do |line| 
      l = {}
      ["count", "rate", "amount", "unit_id", "project_id","line_type","description","account_id","payroll_tax","vacation_basis","salary_code"].each do |key|
        l[key] = line.attributes[key]
      end
      l['paycheck_line_template_id'] = line.id
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

  def make_journal paycheck

    if paycheck.journal != nil
      paycheck.journal.journal_operations.each do
        |op|
        op.destroy
      end
      j = paycheck.journal
    else
      j = Journal.new
    end

    j.journal_type = 1
    j.journal_date = paycheck.updated_at
    j.company = @me.current_company
    j.period_id = paycheck.period_id
    j.closed = true
    j.save
    ops = {}
    
    paycheck.paycheck_lines.each do
      |line|
      if line.line_type != PaycheckLineTemplate::TYPE_INFO

        base_amount = -line.amount
        if line.line_type == PaycheckLineTemplate::TYPE_EXPENSE
          base_amount = -base_amount
        end
        
        if ops[line.account.id] == nil
          ops[line.account.id] = {:amount => 0.0, :account => line.account }
        end

        ops[line.account.id] = {:amount => ops[line.account.id][:amount] + base_amount, :account => line.account }
        
      end
    end
    
    print "COUNT: #{ops.count}\n"

    tot = 0
    ops.each do
      |key, value|
      
      op = JournalOperation.new
      op.amount = value[:amount]
      op.journal = j
      op.account = value[:account]

      tot += value[:amount]
      op.vat = 0
      op.vat_account_id = nil
      #        op.unit = line.unit
      #        op.project = line.project
      # op.ledger = paycheck.employee
      op.save
      
    end
      
    op = JournalOperation.new
    op.amount = -tot
    op.journal = j
    op.account = paycheck.employee.account
    op.vat = 0
    op.vat_account_id = nil
    #        op.unit = line.unit
    #        op.project = line.project
    op.ledger = paycheck.employee
    op.save
      



    paycheck.journal = j
    paycheck.save
  end

  # POST /paychecks
  # POST /paychecks.xml
  def create
    @paycheck = Paycheck.new(params[:paycheck])
    user_company_property("paycheck.paycheck_period_id", nil)
    user_company_property("paycheck.period_id", nil)
    
    respond_to do |format|
      Paycheck.transaction do
        if @paycheck.save
          make_journal @paycheck
          format.html { redirect_to(@paycheck, :notice => 'Paycheck was successfully created.') }
          format.xml  { render :xml => @paycheck, :status => :created, :location => @paycheck }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @paycheck.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  # PUT /paychecks/1
  # PUT /paychecks/1.xml
  def update
    @paycheck = Paycheck.find(params[:id])

    respond_to do |format|
      if @paycheck.update_attributes(params[:paycheck])
        make_journal @paycheck
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
