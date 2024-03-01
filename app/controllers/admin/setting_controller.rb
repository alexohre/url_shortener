class Admin::SettingController < AdminController
  def account
    @title = "Account Details"
    @resource = current_user
    @resource_name = :user
  end

  def admin_password
    @title = "Account Password"
    @resource = current_user
    @resource_name = :user
  end

  def site_details
    @title = "Site Contact Details"

     @site = Site.first_or_initialize
  end

  def currency_pairs
    @title = "Currency Pairs"
    @currency_pair = CurrencyPair.new

    @pagy, @currency_pairs = pagy(CurrencyPair.all, items: 5)
  end

  def payment_methods
    @title = "Payment Method" 

    @payment_method = PaymentMethod.new
    @payment_methods = PaymentMethod.all
  end

end