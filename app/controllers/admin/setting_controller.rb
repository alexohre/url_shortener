class Admin::SettingController < AdminController
  def account
    @title = "Account Details"
  end

  def site_details
    @title = "Site Contact Details"

     @site = Site.first_or_initialize
  end

end