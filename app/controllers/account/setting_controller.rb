class Account::SettingController < AccountController
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

end