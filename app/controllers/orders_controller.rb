class OrdersController < ApplicationController
  before_filter :company_required

  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find(@me.current_company.orders, :order => 'updated_at')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new
    @order.delivery_address = Address.new
    @products_all = (Account.find(@me.current_company.accounts, :include => [ :products ]
			          ).collect { |account| account.products}).flatten

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @products_all = (Account.find(@me.current_company.accounts, :include => [ :products ]
			          ).collect { |account| account.products}).flatten
  end
  
  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.delivery_address = Address.new(params[:address])
    @order.company_id = @me.current_company.id
    respond_to do |format|
      Order.transaction do
        begin
          @order.save!
          @order.delivery_address.save!
          params[:products].each {
            |key, value|
	    item = OrderItem.new(value)
            if item.amount > 0
	      @order.order_items << item
              item.save!
            end
          }
          flash[:notice] = 'Order was successfully created.'
          format.html { redirect_to(@order) }
          format.xml  { render :xml => @order, :status => :created, :location => @order }
        rescue Exception => e
	  puts e.inspect
          format.html { render :action => "new" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
	  raise
        end
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      Order.transaction do
        begin
          flash[:notice] = 'Save order.'
          @order.update_attributes(params[:order]) or raise ActiveRecord::Rollback
          @order.delivery_address.update_attributes(params[:address]) or raise ActiveRecord::Rollback

          params[:products].each {
            |key, value|
            value[:order_id] = @order.id
            if value[:id] != nil
              op = OrderItem.find(value[:id])
              if op.amount > 0
                flash[:notice] = 'Update item.'
                op.update_attributes(value) or raise ActiveRecord::Rollback
              else
                flash[:notice] = 'DESTROY THE UNBELIVERS!!!'
                op.destroy
              end
            else
              op = OrderItem.new(value)
              if op.amount > 0
                flash[:notice] = 'Save new item.'
                op.save or raise ActiveRecord::Rollback
              end
            end
          }
          
          flash[:notice] = 'Order was successfully updated.'
          format.html { redirect_to(@order) }
          format.xml  { head :ok }
        rescue ActiveRecord::Rollback
          format.html { render :action => "edit" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
