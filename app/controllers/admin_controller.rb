class AdminController < ActionController::Base
  # before_action :authenticate_user!
  include Pagy::Backend
  layout "admin"
end