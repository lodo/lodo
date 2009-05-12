class LedgersController < ApplicationController
  before_filter :company_required
  before_filter :load_ledger, :only => [:show, :edit, :update, :destroy]
  before_filter :right_company, :only => [:show, :edit, :update, :destroy]

  def load_ledger
    @ledger = Ledger.find(params[:id])

    if params[:account_id] && params[:account_id].to_i != 0
      raise "account_id incorrect" if @ledger.account_id != params[:account_id].to_i
    end
  end

  def right_company
    if @me.companies.include? @ledger.company
      @me.current_company = @ledger.company
      return true
    end

    flash[:notice]='You can only manage your own ledgers. Go away.'
    redirect_to :action => "index"
    return false 
  end
  
  def create
    @ledger = Ledger.new(params[:ledger])
    @ledger.account_id = params[:account_id]
    raise "account does not belong to active company" if @ledger.account.company != @me.current_company
    if @ledger.save
      respond_to do |format|
        format.json { render :json => @ledger.to_json(:include => {:unit => {}, :project => {} }) }
        format.html { redirect_to @ledger.account }
        format.xml { head :ok }
      end
    else
      flash[:ledger] = @ledger
      raise @ledger.errors.full_messages.join(", ")
    end
  end

  def update
    @ledger.update_attributes!(params[:ledger])
    respond_to do |format|
      format.html do
        flash[:notice] = t(:ledger_saved, :scope => :ledgers, :name => @ledger.name)
        redirect_to edit_account_path(@ledger.account)
      end
      format.json { head :ok }
      format.xml { head :ok }
    end
  end

  def new
    @account = Account.find(params[:account_id])
    @ledger = Ledger.new(:account => @account)
    @ledger.address = Address.new
    respond_to do |format|
      format.json { render :json => @ledger.to_json(:include => [:account,
                                                                 :address,
                                                                 :unit,
                                                                 :project]
                                                    )
      }
      @account = @ledger.account
      format.html { render :partial => "accounts/ledger_form", :locals => {:account => @account, :ledger => @ledger} }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => @ledger.to_json(:include => [:account,
                                                                 :address,
                                                                 :unit,
                                                                 :project]
                                                    )
      }
      @account = @ledger.account
      format.html { render :partial => "accounts/ledger_form", :locals => {:account => @account, :ledger => @ledger} }
    end
  end

end
