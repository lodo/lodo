class PaycheckPeriodsController < ApplicationController
  # GET /paycheck_periods
  # GET /paycheck_periods.xml
  def index
    @paycheck_periods = PaycheckPeriod.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paycheck_periods }
    end
  end

  # GET /paycheck_periods/1
  # GET /paycheck_periods/1.xml
  def show
    @paycheck_period = PaycheckPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck_period }
    end
  end

  # GET /paycheck_periods/new
  # GET /paycheck_periods/new.xml
  def new
    @paycheck_period = PaycheckPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paycheck_period }
    end
  end

  # GET /paycheck_periods/1/edit
  def edit
    @paycheck_period = PaycheckPeriod.find(params[:id])
  end

  # POST /paycheck_periods
  # POST /paycheck_periods.xml
  def create
    @paycheck_period = PaycheckPeriod.new(params[:paycheck_period])
    @paycheck_period.company = @me.current_company

    respond_to do |format|
      if @paycheck_period.save
        format.html { redirect_to(@paycheck_period, :notice => 'Paycheck period was successfully created.') }
        format.xml  { render :xml => @paycheck_period, :status => :created, :location => @paycheck_period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paycheck_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paycheck_periods/1
  # PUT /paycheck_periods/1.xml
  def update
    @paycheck_period = PaycheckPeriod.find(params[:id])

    respond_to do |format|
      if @paycheck_period.update_attributes(params[:paycheck_period])
        @paycheck_period.company = @me.current_company
        format.html { redirect_to(@paycheck_period, :notice => 'Paycheck period was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck_period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paycheck_periods/1
  # DELETE /paycheck_periods/1.xml
  def destroy
    @paycheck_period = PaycheckPeriod.find(params[:id])
    @paycheck_period.destroy

    respond_to do |format|
      format.html { redirect_to(paycheck_periods_url) }
      format.xml  { head :ok }
    end
  end
end
