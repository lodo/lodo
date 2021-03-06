# chart of accounts
class AccountsController < ApplicationController
  filter_resource_access

  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.with_permissions_to(:index).all(:order => "number")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts } 
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
  end
  
  # POST /accounts
  # POST /accounts.xml
  def create
    # Set the company manually
    @account.company = @me.current_company
    respond_to do |format|
      if @account.save
        flash[:notice] = t(:account_created, :scope => :accounts)
        format.html { redirect_to(@account) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = t(:account_updated, :scope => :accounts)
        format.html { redirect_to(@account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account.destroy
    
    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
    end
  end
end
