class Private::CrewsController < ApplicationController

  layout "private"
  filter_access_to :all

  def index
    @crews = Crew.includes(:jobs, :equipments, :users).order('name ASC')
    @unassigned_equipment = Equipment.unassigned
    @page_title = "Crews"
  end

  def new
    @crew = Crew.new
    @users = User.where(:employment_state => 'Employed').order("first_name ASC")
    @equipment = Equipment.order(:unit).all
    @page_title = "New Crew"
  end

  def create
    @users = User.where(:employment_state => 'Employed').order("first_name ASC")
    @equipment = Equipment.order(:unit).all
    @crew = Crew.new
    @crew.clear_used_equipment_from_other_crews(params[:crew][:equipment_ids])
    @crew = Crew.new(params[:crew])
    @page_title = "New Crew"
    if @crew.save
      flash[:notice] = "Crew created!"
      redirect_to private_crews_url
    else
      render :action => :new
    end
  end

  def show
    @crew = Crew.find(params[:id])
    @page_title = "Show #{@crew.name}"
  end

  def edit
    @crew = Crew.find(params[:id])
    @users = User.where(:employment_state => 'Employed').order("first_name ASC")
    @equipment = Equipment.order(:unit).all
    @page_title = "Edit #{@crew.name}"
  end

  def update
    @users = User.where(:employment_state => 'Employed').order("first_name ASC")
    @equipment = Equipment.order(:unit).all
    params[:crew][:user_ids] ||= []
    params[:crew][:equipment_ids] ||= []
    @crew = Crew.find(params[:id])
    @crew.clear_used_equipment_from_other_crews(params[:crew][:equipment_ids])

    if @crew.update_attributes(params[:crew])
      flash[:notice] = "Crew updated!"
      redirect_to private_crews_url
    else
      render :action => :edit
    end
  end

  def destroy
    @crew = Crew.find(params[:id])
    @crew.destroy
    flash[:notice] = 'Crew deleted!'
    redirect_to(private_crews_url)
  end

end
