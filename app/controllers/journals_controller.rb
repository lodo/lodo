class JournalsController < ApplicationController
  before_filter :company_required
  before_filter :find_accounts_all, :only => [:new, :edit]
  before_filter :load_journal, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]
  before_filter :open_required, :only => [:update, :destroy, :edit]  

  def load_journal
    @journal = Journal.find(params[:id])
  end

  def right_company
    if @me.companies.include? @journal.company
      @me.current_company = @journal.company
      return true
    end

    flash[:notice]='You can only manage your own journals. Go away.'
    redirect_to :action => "index"
    return false 
  end

  # GET /journals
  # GET /journals.xml
  def index
    @journals = Journal.find(:all)
    
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
          @journal.save or raise ActiveRecord::Rollback
          params[:journal_operations].each {
            |key, value|
            value[:journal_id] = @journal.id
            op = JournalOperation.new(value)
            if op.amount != 0.0
              op.save or raise ActiveRecord::Rollback
            end
          }
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

          # FIXME: This is an ugly way to save things.  Lot's of work,
          # and no transactional safety.  Can we move this to the save
          # method of the model, or is that not railsy?
          params[:journal_operations].each {
            |key, value|
            value[:journal_id] = @journal.id
            if value[:id] != nil
              op = JournalOperation.find(value[:id])
              if op.amount > 0.0
                op.update_attributes(value)  or raise ActiveRecord::Rollback
              else
                op.destroy
              end
            else
              op = JournalOperation.new(value)
              if op.amount > 0.0
                op.save  or raise ActiveRecord::Rollback
              end
            end
          }

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
      Account.find(:all, 
                   :conditions => {:company_id => @me.current_company.id}, 
                   :order => :number)
  end

  def open_required
    if Journal.find(params[:id]).editable?
      return true
    end
    flash[:notice] = 'Journal is closed'
    redirect_to :action => "show"
    return false
  end
  
end
