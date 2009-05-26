class PeriodsController < ApplicationController
  before_filter :company_required
  before_filter :load_period, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]

  def load_period
    @period = Period.find(params[:id])
  end

  def right_company
    if @me.companies.include? @period.company
      @me.current_company = @period.company
      @me.save!
      return true
    end

    flash[:notice]='You can only manage your own periods. Go away.'
    redirect_to :action => "index"
    return false 
  end

  # GET /periods
  # GET /periods.xml
  def index
    @periods = @me.current_company.periods.sort { |a,b| a.year != b.year ? b.year <=> a.year : b.nr <=> a.nr }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @periods }
    end
  end

  # GET /periods/1
  # GET /periods/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @period }
    end
  end

  # GET /periods/new
  # GET /periods/new.xml
  def new
    @period = Period.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @period }
    end
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  # POST /periods.xml
  def create
    @period = Period.new(params[:period])
    @period.company = @me.current_company

    respond_to do |format|
      if @period.save
        flash[:notice] = 'Period was successfully created.'
        format.html { redirect_to(@period) }
        format.xml  { render :xml => @period, :status => :created, :location => @period }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /periods/1
  # PUT /periods/1.xml
  def update
    respond_to do |format|
      if @period.update_attributes(params[:period])
        flash[:notice] = 'Period was successfully updated.'
        format.html { redirect_to(@period) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @period.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.xml
  def destroy
    @period.destroy

    respond_to do |format|
      format.html { redirect_to(periods_url) }
      format.xml  { head :ok }
    end
  end
end
