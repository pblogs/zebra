class UsersController < ApplicationController

  layout "private"
  filter_access_to [:show, :edit, :update], :attribute_check => true
  filter_access_to :index, :attribute_check => false

  def index
    if(params[:showonly] == 'inactive')
      @users = User.where("eployment_state NOT LIKE ?", 'Employed').includes(:roles).order(:first_name)
    else
      @users = User.where(:employment_state => "Employed").includes(:roles).order(:first_name)
    end

    @page_title = "Users"

    @search = User.search(params[:search])

    if params[:commit] == "Search"
      @users = @search.all
    end
  end

  def new
    @user = User.new
    @page_title = "New User"
  end

  def create
    @user = User.new(params[:user])
    @user.role_ids = params[:user][:role_ids]
    params[:user][:role_ids] ||= []
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to users_url
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id], :include => :roles)
    @page_title = "#{@user.first_name} #{@user.last_name} details"
    if params[:version]
      if params[:version].to_i >= @user.last_version
        params[:version] = nil
      else
        @user.revert_to(params[:version].to_i)
      end
    end
    if @user.versioned_role_ids
      @roles = Role.where(:id => @user.versioned_role_ids.split(", ")).all
    end
  end

  def edit
    @user = User.find(params[:id], :include => :roles)
    @page_title = "Edit #{@user.first_name} #{@user.last_name}"
  end

  def update
    @user = User.new(params[:user])
    @user = User.find(params[:id])
    if params[:user][:role_ids] then
      @user.versioned_at = Time.now
      @user.versioned_role_ids = params[:user][:role_ids].join(', ').to_s
      params[:user][:role_ids] ||= []
    end
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to private_home_url
    else
      render :action => :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User was deleted.'
    redirect_to(users_url)
  end

  def revert
    @user = User.find(params[:id])
    @user.revert_to(params[:version].to_i)
    @user.role_ids = @user.versioned_role_ids.split(", ")
    @user.versioned_at = Time.now
    @user.save!
    flash[:notice] = "User reverted!"
    redirect_to user_url(@user)
  end

end
