class Admin::SitesController < ApplicationController
  before_action :set_site, only: [:edit, :update]

  def create
    @site = Site.new(site_params)
    if @site.save
      redirect_to admin_settings_site_details_path, notice: 'Site contact details successfully created.'
    else
      redirect_to admin_settings_site_details_path, alert: "Please fill all the fields"
    end
  end

  def update
    if @site.update(site_params)
      redirect_to admin_settings_site_details_path, notice: 'Site contact details successfully updated.'
    else
      redirect_to admin_settings_site_details_path, alert: "Please fill all the fields"
    end
  end

  private
  def set_site
    @site = Site.first
  end

  def site_params
    params.require(:site).permit(:contact_number, :contact_email, :contact_address)
  end
end
