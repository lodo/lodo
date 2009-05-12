class BillsController < ApplicationController
  before_filter :company_required
  before_filter :load_bill, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]

  def load_bill
    @bill = Bill.find(params[:id])
  end

  def right_company
    if @me.companies.include? @bill.company
      @me.current_company = @bill.company
      return true
    end

    flash[:notice]='You can only manage your own bills. Go away.'
    redirect_to :action => "index"
    return false 
  end

  # GET /bills
  # GET /bills.xml
  def index
    @bills = Bill.find(@me.current_company.bills, :order => 'updated_at')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end
  
  # GET /bills/1
  # GET /bills/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
    end
  end

  def get_all_orders
    @orders_all = Order.find(
      :all,
      :joins => :company,
      :conditions => ["orders.company_id = ?", @me.current_company.id ],
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
", @me.current_company.id])
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
  end

  def post_to_model(post)
    bill_model = Hash.new
    post = post.clone()

    ['price',
     'delivery_date(1i)', 
     'delivery_date(2i)',
     'delivery_date(3i)',
     'billing_date(1i)',
     'billing_date(2i)',
     'billing_date(3i)'].each do |name|
     bill_model[name] = post.delete name
    end

    bill_model['bill_orders'] = []

    post.values.each do |bill_order_post|
      bill_order_model = Hash.new
      bill_order_model['order_id'] = bill_order_post['order_id']
      bill_order_post = bill_order_post['details'].clone()

      bill_order_model['price'] = bill_order_post.delete 'price'
      bill_order_post.delete 'amount'
      bill_order_post.delete 'discount'

      bill_order_model['bill_items'] = bill_order_post.values.map do |item|
	item = item.clone()
	item.delete 'discount'
	BillItem.create_or_update(item)
      end

      bill_model['bill_orders'].push(BillOrder.create_or_update(bill_order_model))
    end

    Bill.create_or_update(bill_model)
  end


  # POST /bills
  # POST /bills.xml
  def create
    @bill = post_to_model params[:bill]
    @bill.company_id = @me.current_company.id

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
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to(bills_url) }
      format.xml  { head :ok }
    end
  end
end
