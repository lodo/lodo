class UsersController < ApplicationController
  skip_before_filter :login_required, :only => ['login', 'new', 'forgot_password', 'create']

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end

  end
  
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user] = @user
        flash[:notice] = 'You have been registered.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def login
    if request.post?
      if session[:user] = User.authenticate(params[:login], params[:password])
        if not session[:user].current_company or not session[:user].current_company.in(session[:user].companies) and session[:user].companies.length > 0
            session[:user].current_company = session[:user].companies[0]
            session[:user].save
        end
        
        flash[:notice]  = "Login successful"

	if session[:return_to]
          redirect_to session[:return_to]
        else
          redirect_to :action => :show, :id => session[:user].id
        end      
      else
        flash[:notice] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'login'
  end

  def forgot_password
    if request.post?
      u= User.find_by_email(params[:email])
      if u and u.send_new_password
        flash[:message]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end
  
  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
      end
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def index
    @users = User.find(:all, :order => :login)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def change_current_company
    session[:user].current_company = Company.find(params[:current_company])
    session[:user].save
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

end
