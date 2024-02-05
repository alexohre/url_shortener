class Admin::DepositController < AdminController
  def pending
    @title = "Pending Deposit"
  end

  def approved
    @title = "Approved Deposit"
  end

  def declined 
    @title = "Declined Deposit"
  end

  def show
    @title = "Deposit show"
  end
end