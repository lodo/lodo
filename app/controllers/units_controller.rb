class UnitsController < ApplicationController
  before_filter :company_required
  before_filter :load_unit, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]

  def load_unit
    @unit = Unit.find(params[:id])
  end

  def right_company
    if @me.companies.include? @unit.company
      @me.current_company = @unit.company
      return true
    end
    flash[:notice] = "You can only manage your own data, Go away."
    reditect_to :action => "index"
    return false
  end


  # GET /units
  # GET /units.xml
  def index
    @units = @me.current_company.units

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @units }
    end
  end

  # GET /units/1
  # GET /units/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unit }
    end
  end

  # GET /units/new
  # GET /units/new.xml
  def new
    @unit = Unit.new
    @unit.address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unit }
    end
  end

  # GET /units/1/edit
  def edit
    @unit.address = Address.new if @unit.address.nil?
  end

  # POST /units
  # POST /units.xml
  def create
    @unit = Unit.new(params[:unit])
    @unit.company = @me.current_company

    respond_to do |format|
      if @unit.save
        flash[:notice] = 'Unit was successfully created.'
        format.html { redirect_to(@unit) }
        format.xml  { render :xml => @unit, :status => :created, :location => @unit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /units/1
  # PUT /units/1.xml
  def update
    respond_to do |format|
      if @unit.update_attributes(params[:unit])
        flash[:notice] = 'Unit was successfully updated.'
        format.html { redirect_to(@unit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @unit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.xml
  def destroy
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to(units_url) }
      format.xml  { head :ok }
    end
  end
end
