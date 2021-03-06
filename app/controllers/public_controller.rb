class PublicController < ApplicationController

  layout "public"
  before_filter :check_for_mobile, :except => :home

  def home
    @user_session = UserSession.new
  end

  def about
  end

  def contacts_redirect
    redirect_to new_contact_path
  end

  def services
  end

  def products
  end

  def suppliers
  end

  def careers
  end

  def remove_paint_on_a_car
  end

  def equipment_for_sale
  end

  def services_aggolmerate
  end

  def services_aquaflex_intermix
  end

  def services_highway_beacon
  end

  def services_hot_thermoplastic
  end

  def services_line_painting
  end

  def services_line_removal
  end

  def services_mma_durables
  end

  def services_seal_coating
  end

  def services_fast_dry_paint
  end

  def services_parking_lot_maintenance
  end

  def wet_night_aggolomerate
  end

  def wet_night_dotflex
  end

  def wet_night_droponlinetm
  end

  def products_mma_cold_plastic
  end

  def products_aquaplast
  end

  def products_cleanosol
  end

  def products_glass_bead
  end

  def products
  end

  def suppliers
  end

private

  def check_for_mobile
    if is_mobile_device? then redirect_to :action => "home" end
  end
end
