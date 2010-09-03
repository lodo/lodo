class PeriodsController < ApplicationController
  filter_resource_access

  # GET /periods
  # GET /periods.xml
  def index
    @periods = Period.with_permissions_to(:index).all(:order => "year desc, nr desc").paginate({:page => params[:page]})
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
