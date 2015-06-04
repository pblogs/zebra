class Private::SettingsController < ApplicationController
  layout "private"
  filter_access_to :all

  def index
    @setting = Setting.first
    @page_title = "App Settings"
  end

  def edit
    @setting = Setting.first
    @page_title = "Edit App Settings"
  end

  def update
    @setting = Setting.first
    @page_title = "App Settings"

    if @setting && @setting.update_attributes(params[:setting])
      flash[:notice] = "App Settings updated!"
      redirect_to private_settings_path
    else
      render action: :edit
    end
  end
end
