class Admin::CompaniesController < Admin::BaseController

  before_filter :find_company, :only => [:show, :edit, :update, :destroy]

  def find_company
    @company = Company.find(params[:id])
    if !@company.address
      @company.address = Address.new
    end
  end

  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.order("name").includes(:assignments).includes(:address).paginate({:page => params[:page]})
    @companies.each do
      |c| 
      if !c.address 
        c.address = Address.new
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new
    @company.address = Address.new
    3.times { @company.assignments.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    3.times { @company.assignments.build }
  end

  # POST /companies
  # POST /companies.xml
  def create
    users = params[:company][:user_ids]
    params[:company][:user_ids] = nil
    @company = Company.new(params[:company])
    @company.address ||= Address.new
    
    respond_to do |format|
      if @company.save
        @company.user_ids = users
        if @company.save
          flash[:notice] = 'Company was successfully created.'
          format.html { redirect_to([:admin, @company]) }
          format.xml  { render :xml => @company, :status => :created, :location => @company }
        else
          3.times { @company.assignments.build }
          format.html { render :action => "new" }
          format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /companies/1
  # PUT /companies/1.xml
  def update

    respond_to do |format|
      if @company.update_attributes(params[:company]) && @company.address.update_attributes(params[:address])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to([:admin, @company]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(admin_companies_url) }
      format.xml  { head :ok }
    end
  end
end
