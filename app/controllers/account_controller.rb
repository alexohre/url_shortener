class AccountController < ActionController::Base
  before_action :authenticate_account!
  # before_action :check_profile_completion

  include Pagy::Backend
  layout "account"

  private

  # def check_profile_completion
  #   if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank?)
  #     redirect_to edit_account_registration_path, alert: "Please complete your profile information."
  #   end
  # end

end