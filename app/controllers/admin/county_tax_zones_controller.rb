class Admin::CountyTaxZonesController < Admin::BaseController
  # GET /county_tax_zones
  # GET /county_tax_zones.xml
  def index
    @county_tax_zones = CountyTaxZone.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @county_tax_zones }
    end
  end

  # GET /county_tax_zones/1
  # GET /county_tax_zones/1.xml
  def show
    @county_tax_zone = CountyTaxZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @county_tax_zone }
    end
  end

  # GET /county_tax_zones/new
  # GET /county_tax_zones/new.xml
  def new
    @county_tax_zone = CountyTaxZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @county_tax_zone }
    end
  end

  # GET /county_tax_zones/1/edit
  def edit
    @county_tax_zone = CountyTaxZone.find(params[:id])
  end

  # POST /county_tax_zones
  # POST /county_tax_zones.xml
  def create
    @county_tax_zone = CountyTaxZone.new(params[:county_tax_zone])

    respond_to do |format|
      if @county_tax_zone.save
        format.html { redirect_to([:admin, @county_tax_zone], :notice => 'County tax zone was successfully created.') }
        format.xml  { render :xml => @county_tax_zone, :status => :created, :location => @county_tax_zone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @county_tax_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /county_tax_zones/1
  # PUT /county_tax_zones/1.xml
  def update
    @county_tax_zone = CountyTaxZone.find(params[:id])

    respond_to do |format|
      if @county_tax_zone.update_attributes(params[:county_tax_zone])
        format.html { redirect_to([:admin, @county_tax_zone], :notice => 'County tax zone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @county_tax_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /county_tax_zones/1
  # DELETE /county_tax_zones/1.xml
  def destroy
    @county_tax_zone = CountyTaxZone.find(params[:id])
    @county_tax_zone.destroy

    respond_to do |format|
      format.html { redirect_to(admin_county_tax_zones_url) }
      format.xml  { head :ok }
    end
  end
end
