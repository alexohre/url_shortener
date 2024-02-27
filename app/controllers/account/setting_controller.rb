class Account::SettingController < AccountController
  before_action :check_profile_completion, only: [:profile]

  def change_password
    @title = "Change Your Password"
    @resource = current_account
    @resource_name = :account
    @error_messages = flash[:alert] if flash[:alert].present?
  end

  def profile
    @resource_name = :account
    name = current_account.first_name.present? ? current_account.first_name : current_account.username
    @title = "#{name}'s Profile"
  end

  private

  def check_profile_completion
    if current_account && (current_account.first_name.blank? || current_account.last_name.blank? || current_account.address.blank? || current_account.state.blank? || current_account.country.blank?)
      redirect_to edit_account_registration_path, alert: "Please complete your profile information."
    end
  end

end