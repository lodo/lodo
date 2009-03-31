class BillsController < ApplicationController
  before_filter :company_required
  
  # GET /bills
  # GET /bills.xml
  def index
    @bills = Bill.find(session[:user].current_company.bills, :order => 'updated_at')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end
  
  # GET /bills/1
  # GET /bills/1.xml
  def show
    @bill = Bill.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  def get_all_orders
    @orders_all = Order.find(
      :all,
      :joins => :company,
      :conditions => ["orders.company_id = ?", session[:user].current_company.id ],
      :include => {
	:seller => {},
	:customer => {},
	:transport => {},
	:company => {},
        :order_items => :product
      })

=begin
    @orders_all = Order.find_by_sql([
"
select
  orders.*
from
 orders, companies
where
     orders.company_id = ?
 and orders.customer_id = companies.id
order by
 companies.name, orders.created_at
", session[:user].current_company.id])
=end
  end

  # GET /bills/new
  # GET /bills/new.xml
  def new
    get_all_orders
    @bill = Bill.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    get_all_orders
    @bill = Bill.find(params[:id])
  end

  # POST /bills
  # POST /bills.xml
  def create
    @bill = Bill.new(params[:bill])
    @bill.company_id = session[:user].current_company.id
    respond_to do |format|
      if @bill.save
        flash[:notice] = 'Bill was successfully created.'
        format.html { redirect_to(@bill) }
        format.xml  { render :xml => @bill, :status => :created, :location => @bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.xml
  def update
    @bill = Bill.find(params[:id])

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        flash[:notice] = 'Bill was successfully updated.'
        format.html { redirect_to(@bill) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(bills_url) }
      format.xml  { head :ok }
    end
  end
end
