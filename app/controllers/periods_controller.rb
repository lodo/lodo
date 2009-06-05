class PeriodsController < ApplicationController
  before_filter :company_required
  before_filter :load_period, :only => [:elevate_status, :move_bills]
  before_filter :right_company, :only => [:elevate_status, :move_bills]

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

  # GET /periods/new
  # GET /periods/new.xml
  def new
    @me.current_company.last_period.create_next.save!

    respond_to do |format|
      format.html { redirect_to(periods_url) }
      format.xml  { head :ok }
    end
  end

  # GET /periods/move_bills
  def move_bills
    respond_to do |format|
      format.html
      format.xml  { render :xml => @periods }
    end
  end

  def elevate_status
    respond_to do |format|
      if not params.nil? and not params[:new_period_id].nil?
	new_period = Period.find(params[:new_period_id])
	@period.move_open_bills new_period
	@period.save!
	new_period.save!
      end

      if @period.status_elevation_requires_closing_bills?
	format.html { redirect_to :id => @period.id, :action => :move_bills }
	format.xml  { head :ok }
      else
	@period.elevate_status
	@period.save!
	format.html { redirect_to(periods_url) }
	format.xml  { head :ok }
      end
    end
  end
end
