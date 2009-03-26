class OrdersController < ApplicationController
  before_filter :login_required
  before_filter :company_required

  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find(:all)

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
    @products_all = Product.find(session[:user].current_company.products, :order => 'name')
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @products_all = Product.find(session[:user].current_company.products, :order => 'name')
  end
  
  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    
    respond_to do |format|
      Order.transaction do
        begin
          @order.save or raise ActiveRecord::Rollback
          params[:products].each {
            |key, value|
            value[:order_id] = @order.id
            item = OrderItem.new(value)
            if item.amount > 0
              item.save or raise ActiveRecord::Rollback
            end
          }
          flash[:notice] = 'Order was successfully created.'
          format.html { redirect_to(@order) }
          format.xml  { render :xml => @order, :status => :created, :location => @order }
        rescue ActiveRecord::Rollback
          format.html { render :action => "new" }
          format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
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
          @order.update_attributes(params[:order]) or raise ActiveRecord::Rollback

          params[:products].each {
            |key, value|
            value[:order_id] = @order.id
            if value[:id] != nil
              op = OrderItem.find(value[:id])
              if op.amount > 0
                op.update_attributes(value)  or raise ActiveRecord::Rollback
              else
                op.destroy
              end
            else
              op = OrderItem.new(value)
              if op.amount > 0
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
