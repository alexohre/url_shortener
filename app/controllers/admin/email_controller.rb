class Admin::EmailController < AdminController
  def sent
    @title = "Sent mails"
  end

  def new
    @title = "New email"
  end
end