# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :set_layout

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    if updating_password?
      update_password
    else
      super
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def after_update_path_for(resource)
    admin_dashboard_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username, :avatar])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   new_user_session_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  private

  def update_password
    if resource.update_with_password(password_params)
      bypass_sign_in(resource)
      redirect_to after_update_path_for(resource), notice: "Your password has been updated successfully."
    else
      # error_message = resource.errors.full_messages.join("\n ")
      render :admin_password, status: :unprocessable_entity
      # redirect_to account_settings_change_password_path, alert: "Failed to update password: #{error_message}".html_safe
    end
  end

  def updating_password?
    params.key?(:user) && params[:user].key?(:password) && params[:user].key?(:password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def set_layout
    if action_name == "edit" || action_name == "update"
      self.class.layout "admin"
    else
      self.class.layout "auth"
    end
  end
end
