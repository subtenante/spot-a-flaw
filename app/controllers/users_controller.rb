class UsersController < ApplicationController

  # GET /users
  # GET /users.xml
  def index
    if not admin_user
        flash[:error] = "You can't list the user profiles"
        redirect_to root_url
        return
    end
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    unless can_edit_user(User.find(params[:id]))
      flash[:error] = "You can't view this profile"
      redirect_to root_url
      return
    end

    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    unless can_register
      flash[:error] = "You must logout before signing up with another account"
      redirect_to root_url
      return
    end

    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    if params[:id]=='current'
      @user = current_user
    else
      unless can_edit_user(User.find params[:id])
        flash[:error] = "You can't edit this profile"
        redirect_to root_url
        return
      end
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.enabled = false
    @user.admin = false
    @user.notified = true
    respond_to do |format|
      if @user.save
        Notificator.deliver_new_registered_user(@user)
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    unless admin_user or @user.enabled
        params[:user][:enabled] = false
    end
    unless admin_user or @user.admin
        params[:user][:admin] = false
    end

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

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    unless can_edit_user(@user)
      flash[:error] = 'Forbidden action.'
      redirect_to root_url
    end

    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

end
