class Admin::TaxZonesController < Admin::BaseController
  # GET /tax_zones
  # GET /tax_zones.xml
  def index
    @tax_zones = TaxZone.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tax_zones }
    end
  end

  # GET /tax_zones/1
  # GET /tax_zones/1.xml
  def show
    @tax_zone = TaxZone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tax_zone }
    end
  end

  # GET /tax_zones/new
  # GET /tax_zones/new.xml
  def new
    @tax_zone = TaxZone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tax_zone }
    end
  end

  # GET /tax_zones/1/edit
  def edit
    @tax_zone = TaxZone.find(params[:id])
  end

  # POST /tax_zones
  # POST /tax_zones.xml
  def create
    @tax_zone = TaxZone.new(params[:tax_zone])

    respond_to do |format|
      if @tax_zone.save
        format.html { redirect_to([:admin, @tax_zone], :notice => 'Tax zone was successfully created.') }
        format.xml  { render :xml => @tax_zone, :status => :created, :location => @tax_zone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tax_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tax_zones/1
  # PUT /tax_zones/1.xml
  def update
    @tax_zone = TaxZone.find(params[:id])

    respond_to do |format|
      if @tax_zone.update_attributes(params[:tax_zone])
        format.html { redirect_to([:admin, @tax_zone], :notice => 'Tax zone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tax_zone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tax_zones/1
  # DELETE /tax_zones/1.xml
  def destroy
    @tax_zone = TaxZone.find(params[:id])
    @tax_zone.destroy

    respond_to do |format|
      format.html { redirect_to(admin_tax_zones_url) }
      format.xml  { head :ok }
    end
  end
end
