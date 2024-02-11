class AccountController < ActionController::Base
  before_action :authenticate_account!
  # before_action :check

  # def check
  #  if current_account.present? && current_account.account_no.blank? || current_account.account_name.blank? || current_account.bank_name.blank?
  #   flash[:alert] = "Update your bank details"
  #   redirect_to edit_account_registration_path
  #  end
  # end

  # include Pagy::Backend
  layout "account"
end