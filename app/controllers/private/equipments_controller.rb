class Private::EquipmentsController < ApplicationController

  layout "private"
  filter_access_to :all

  def index
    @equipment = Equipment.order("name ASC")
    @page_title = "Equipment"
  end

  def show
    @equipment = Equipment.find(params[:id])
    @page_title = @equipment.name
  end

  def new
    @equipment = Equipment.new
    @page_title = "New Equipment"
  end

  def create
    @equipment = Equipment.new(params[:equipment])
    if @equipment.save
      flash[:notice] = "Equipment created!"
      redirect_to private_equipments_url
    else
      render :action => :new
    end
  end

  def edit
    @equipment = Equipment.find(params[:id])
    @page_title = "Edit #{@equipment.name}"
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update_attributes(params[:equipment])
      flash[:notice] = "Equipment updated!"
      redirect_to private_equipment_path(@equipment)
    else
      render :action => :edit
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    flash[:notice] = 'Equipment deleted!'
    redirect_to private_equipments_url
  end

  def delete_document
    @equipment = Equipment.find(params[:id])
    document = @equipment.assets.find(params[:asset_id])
    document.destroy

    flash[:notice] = 'Equipment document deleted!'
    redirect_to  private_equipment_path(@equipment)
  end
end
