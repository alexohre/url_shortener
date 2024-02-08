class Admin::SettingController < AdminController
  def account
    @title = "Account Details"
  end

  def site_details
    @title = "Site Contact Details"

     @site = Site.first_or_initialize
  end

  def currency_pairs
    @title = "Currency Pairs"
    @currency_pair = CurrencyPair.new

    @currency_pairs = CurrencyPair.all
  end

end