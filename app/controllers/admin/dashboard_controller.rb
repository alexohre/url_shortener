class Admin::DashboardController < AdminController
  def home
    @title = "Home"
  end

  def users
    @title = "Users"
  end
end
