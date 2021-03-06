class JournalsController < ApplicationController

  include PeriodController

  before_filter :find_units_all, :only => [:new, :edit]
  before_filter :find_projects_all, :only => [:new, :edit]
  before_filter :find_accounts_all, :only => [:new, :edit]
  filter_resource_access

  # GET /journals
  # GET /journals.xml
  def index
    @journals = period_filter(Journal.with_permissions_to(:index).order("number, journal_date desc, journal_type")).paginate({:page => params[:page]})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journals }
    end
  end

  
  # GET /journals/1
  # GET /journals/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end
  
  # GET /journals/new
  # GET /journals/new.xml
  def new
    @journal = Journal.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
  end

  # POST /journals
  # POST /journals.xml
  def create
    respond_to do |format|
      Journal.transaction do
        begin
          @journal = Journal.new(params[:journal])
          @journal.company = @me.current_company
          params[:journal_operations].each do
            |key, value|
            op = JournalOperation.new(value)
            if op.amount != 0.0
              @journal.journal_operations.push op 
            end
          end
          @journal.save!
          raise Authorization::NotAuthorized unless permitted_to? :create, @journal

          flash[:notice] = 'Journal was successfully created.'
          format.html { redirect_to(@journal) }
          format.xml  { render :xml => @journal, :status => :created, :location => @journal }
        rescue ActiveRecord::Rollback
          format.html { render :action => "new" }
          format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    respond_to do |format|
      Journal.transaction do
        begin
          @journal.update_attributes(params[:journal]) or raise ActiveRecord::Rollback
          @journal.journal_operations.clear
          params[:journal_operations].each do
            |key, value|
            op = JournalOperation.new(value)
            if op.amount != 0.0
              @journal.journal_operations.push op 
            end
          end
          @journal.save!

          flash[:notice] = 'Journal was successfully updated.'
          format.html { redirect_to(@journal) }
          format.xml  { head :ok }
        rescue ActiveRecord::Rollback
          format.html { render :action => "edit" }
          format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end

  private 
  
  def find_accounts_all
    @accounts_all =
      Account.where(:company_id => @me.current_company.id).order(:number)
  end

  def find_units_all
    @units_all =
      Unit.where(:company_id => @me.current_company.id).order(:name)
  end

  def find_projects_all
    @projects_all =
      Project.where(:company_id => @me.current_company.id).order(:name)
  end

end
