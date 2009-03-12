class JournalOperationsController < ApplicationController
  # GET /journal_operations
  # GET /journal_operations.xml
  def index
    @journal_operations = JournalOperation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journal_operations }
    end
  end

  # GET /journal_operations/1
  # GET /journal_operations/1.xml
  def show
    @journal_operation = JournalOperation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal_operation }
    end
  end

  # GET /journal_operations/new
  # GET /journal_operations/new.xml
  def new
    @journal_operation = JournalOperation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal_operation }
    end
  end

  # GET /journal_operations/1/edit
  def edit
    @journal_operation = JournalOperation.find(params[:id])
  end

  # POST /journal_operations
  # POST /journal_operations.xml
  def create
    @journal_operation = JournalOperation.new(params[:journal_operation])

    respond_to do |format|
      if @journal_operation.save
        flash[:notice] = 'JournalOperation was successfully created.'
        format.html { redirect_to(@journal_operation) }
        format.xml  { render :xml => @journal_operation, :status => :created, :location => @journal_operation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journal_operations/1
  # PUT /journal_operations/1.xml
  def update
    @journal_operation = JournalOperation.find(params[:id])

    respond_to do |format|
      if @journal_operation.update_attributes(params[:journal_operation])
        flash[:notice] = 'JournalOperation was successfully updated.'
        format.html { redirect_to(@journal_operation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal_operation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journal_operations/1
  # DELETE /journal_operations/1.xml
  def destroy
    @journal_operation = JournalOperation.find(params[:id])
    @journal_operation.destroy

    respond_to do |format|
      format.html { redirect_to(journal_operations_url) }
      format.xml  { head :ok }
    end
  end
end
