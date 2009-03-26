class BillItemsController < ApplicationController
  # GET /bill_items
  # GET /bill_items.xml
  def index
    @bill_items = BillItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bill_items }
    end
  end

  # GET /bill_items/1
  # GET /bill_items/1.xml
  def show
    @bill_item = BillItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill_item }
    end
  end

  # GET /bill_items/new
  # GET /bill_items/new.xml
  def new
    @bill_item = BillItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bill_item }
    end
  end

  # GET /bill_items/1/edit
  def edit
    @bill_item = BillItem.find(params[:id])
  end

  # POST /bill_items
  # POST /bill_items.xml
  def create
    @bill_item = BillItem.new(params[:bill_item])

    respond_to do |format|
      if @bill_item.save
        flash[:notice] = 'BillItem was successfully created.'
        format.html { redirect_to(@bill_item) }
        format.xml  { render :xml => @bill_item, :status => :created, :location => @bill_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bill_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bill_items/1
  # PUT /bill_items/1.xml
  def update
    @bill_item = BillItem.find(params[:id])

    respond_to do |format|
      if @bill_item.update_attributes(params[:bill_item])
        flash[:notice] = 'BillItem was successfully updated.'
        format.html { redirect_to(@bill_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bill_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bill_items/1
  # DELETE /bill_items/1.xml
  def destroy
    @bill_item = BillItem.find(params[:id])
    @bill_item.destroy

    respond_to do |format|
      format.html { redirect_to(bill_items_url) }
      format.xml  { head :ok }
    end
  end
end
