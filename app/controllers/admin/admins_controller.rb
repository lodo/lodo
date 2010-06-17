class Admin::AdminsController < Admin::BaseController

  # GET /admin_admins
  # GET /admin_admins.xml
  def index
    @admins = ::Admin.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admin_admins/1
  # GET /admin_admins/1.xml
  def show
    @admin = ::Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admin_admins/new
  # GET /admin_admins/new.xml
  def new
    @admin = ::Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admin_admins/1/edit
  def edit
    @admin = ::Admin.find(params[:id])
  end

  # POST /admin_admins
  # POST /admin_admins.xml
  def create
    @admin = ::Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        flash[:notice] = 'Admin was successfully created.'
        format.html { redirect_to([:admin, @admin]) }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_admins/1
  # PUT /admin_admins/1.xml
  def update
    @admin = ::Admin.find(params[:id])
    # don't update password if blank
    if params[:admin][:password].blank?
      params[:admin].delete :password
      params[:admin].delete :password_confirmation
    end
    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
        format.html { redirect_to([:admin, @admin]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_admins/1
  # DELETE /admin_admins/1.xml
  def destroy
    @admin = ::Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admin_admins_url) }
      format.xml  { head :ok }
    end
  end
end
