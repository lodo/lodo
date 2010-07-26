class PaycheckLinesController < ApplicationController
  # GET /paycheck_lines
  # GET /paycheck_lines.xml
  def index
    raise "aksljdfklasdf"
    @paycheck_lines = PaycheckLine.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paycheck_lines }
    end
  end

  # GET /paycheck_lines/1
  # GET /paycheck_lines/1.xml
  def show
    raise "lsadkfjljwefl"
    @paycheck_line = PaycheckLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paycheck_line }
    end
  end

  # GET /paycheck_lines/new
  # GET /paycheck_lines/new.xml
  def new
    raise "sdfjdlaskjflkwjdsf"
    @paycheck_line = PaycheckLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paycheck_line }
    end
  end

  # GET /paycheck_lines/1/edit
  def edit
    raise "asdljfjadsf"
    @paycheck_line = PaycheckLine.find(params[:id])
  end

  # POST /paycheck_lines
  # POST /paycheck_lines.xml
  def create
    raise "aklsdfjlaksdjf"
    @paycheck_line = PaycheckLine.new(params[:paycheck_line])

    respond_to do |format|
      if @paycheck_line.save
        format.html { redirect_to(@paycheck_line, :notice => 'Paycheck line was successfully created.') }
        format.xml  { render :xml => @paycheck_line, :status => :created, :location => @paycheck_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paycheck_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paycheck_lines/1
  # PUT /paycheck_lines/1.xml
  def update
    raise "aklsdfjslkdf"
    @paycheck_line = PaycheckLine.find(params[:id])

    respond_to do |format|
      if @paycheck_line.update_attributes(params[:paycheck_line])
        format.html { redirect_to(@paycheck_line, :notice => 'Paycheck line was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paycheck_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paycheck_lines/1
  # DELETE /paycheck_lines/1.xml
  def destroy
    raise "asdklfjsahdf"
    @paycheck_line = PaycheckLine.find(params[:id])
    @paycheck_line.destroy

    respond_to do |format|
      format.html { redirect_to(paycheck_lines_url) }
      format.xml  { head :ok }
    end
  end
end
