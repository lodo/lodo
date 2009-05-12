class VatAccountsController < ApplicationController
  before_filter :company_required
  before_filter :load_vat_account, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]

  def load_vat_account
    @vat_account = VatAccount.find(params[:id])
  end

  def right_company
    if @me.companies.include? @vat_account.company
      @me.current_company = @vat_account.company
      return true
    end

    flash[:notice]='You can only manage your own vat accounts. Go away.'
    redirect_to :action => "index"
    return false 
  end


  # GET /vat_accounts
  # GET /vat_accounts.xml
  def index
    @vat_accounts = VatAccount.find(:all)

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

  # POST /vat_accounts
  # POST /vat_accounts.xml
  def create
    @vat_account = VatAccount.new(params[:vat_account])
    @vat_account.company_id = @me.current_company.id

    respond_to do |format|
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

  # PUT /vat_accounts/1
  # PUT /vat_accounts/1.xml
  def update
    respond_to do |format|
      if @vat_account.update_attributes(params[:vat_account])
        flash[:notice] = t(:update_success, :scope => :vat)
        format.html { redirect_to(@vat_account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vat_account.errors, :status => :unprocessable_entity }
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
