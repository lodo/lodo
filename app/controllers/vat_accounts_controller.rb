class VatAccountsController < ApplicationController
  filter_resource_access

  # GET /vat_accounts
  # GET /vat_accounts.xml
  def index
    @vat_accounts = VatAccount.with_permissions_to(:index).where(:company_id => current_user.current_company.id).order("accounts.number").includes("target_account")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vat_accounts }
    end
  end

  # GET /vat_accounts/1
  # GET /vat_accounts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vat_account }
    end
  end

  # GET /vat_accounts/new
  # GET /vat_accounts/new.xml
  def new
    @vat_account = VatAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vat_account }
    end
  end

  # GET /vat_accounts/1/edit
  def edit
  end

  def add_period
    @vat_account.vat_account_periods.push VatAccountPeriod.new(params[:add_period])
  end

  # POST /vat_accounts
  # POST /vat_accounts.xml
  def create
    @vat_account = VatAccount.new(params[:vat_account])
    @vat_account.company_id = @me.current_company.id

    if !params[:periods].nil?
      params[:periods].each do |period|
        @vat_account.vat_account_periods.push VatAccountPeriod.new(period)
      end
    end

    respond_to do |format|
      if params[:commit] == 'Add period'
	self.add_period
	format.html { render :action => "new" }
      else
	if @vat_account.save
	  flash[:notice] = t(:create_success, :scope => :vat)
	  format.html { redirect_to(@vat_account) }
	  format.xml  { render :xml => @vat_account, :status => :created, :location => @vat_account }
	else
	  format.html { render :action => "new" }
	  format.xml  { render :xml => @vat_account.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # PUT /vat_accounts/1
  # PUT /vat_accounts/1.xml
  def update
    @vat_account.attributes = params[:vat_account]

    respond_to do |format|
      if params[:commit] == 'Add period'
	self.add_period
	format.html { render :action => "edit" }
      else
	if @vat_account.save!
	  flash[:notice] = t(:update_success, :scope => :vat)
	  format.html { redirect_to(@vat_account) }
	  format.xml  { head :ok }
	else
	  format.html { render :action => "edit" }
	  format.xml  { render :xml => @vat_account.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # DELETE /vat_accounts/1
  # DELETE /vat_accounts/1.xml
  def destroy
    @vat_account.destroy

    respond_to do |format|
      format.html { redirect_to(vat_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
