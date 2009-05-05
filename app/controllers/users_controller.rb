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
        session[:user_id] = @user.id
        session[:user_hashed_password] = @user.hashed_password
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
      @me = User.authenticate(params[:login], params[:password])
      if @me
        session[:user_id] = @me.id
        session[:user_hashed_password] = @me.hashed_password
        if not @me.current_company or not @me.companies.include?(@me.current_company) and @me.companies.length > 0
          @me.current_company = @me.companies[0]
          @me.save
        end
        
        flash[:notice]  = "Login successful"

	if session[:return_to]
          redirect_to session[:return_to]
        else
          redirect_to :action => :show, :id => @me.id
        end      
      else
        flash[:notice] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_hashed_password] = nil
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
    @user = User.find(params[:id])
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
    @me.current_company = Company.find(params[:current_company])

    if not @me.save
print @me.to_json
      print "Unable to save current company: " + @me.errors.to_json
      flash[:warning] = "Unable to save current company: " + @me.errors.to_json
    end
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

end
