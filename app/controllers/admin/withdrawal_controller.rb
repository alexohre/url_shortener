class Admin::WithdrawalController < AdminController
  def pending
    @title = "Pending Withdrawals"
  end

  def approved
    @title = "Approved Withdrawals"
  end

  def declined 
    @title = "Declined Withdrawals"
  end

  def show
    @title = "Withdrawal show"
  end
end