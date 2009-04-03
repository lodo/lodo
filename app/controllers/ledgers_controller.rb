class LedgersController < ApplicationController
  
  def create
    @ledger = Ledger.new(params[:ledger])
    @ledger.account_id = params[:account_id]
    raise "account belongs to a different company" if @ledger.account.company != session[:user].current_company
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
    @ledger = Ledger.find(params[:id])
    raise "account belongs to a different company" if @ledger.account.company != session[:user].current_company
    @ledger.update_attributes!(params[:ledger])
    respond_to do |format|
      format.html do
        flash[:notice] = "Ledger %s saved." % @ledger.name
        redirect_to edit_account_path(@ledger.account)
      end
      format.json { head :ok }
      format.xml { head :ok }
    end
  end

  def show
    @ledger = nil
    if params[:account_id] && params[:account_id].to_i != 0
      @ledger = Ledger.find(params[:id])
      raise "account_id incorrect" if @ledger.account_id != params[:account_id].to_i
      raise "account belongs to a different company" if @ledger.account.company != session[:user].current_company
    else
      @ledger = Ledger.find(params[:id])
      raise "account belongs to a different company" if @ledger.account.company != session[:user].current_company
    end
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
