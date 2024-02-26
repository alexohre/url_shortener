class Admin::WithdrawalController < AdminController
  def pending
    @title = "Pending Withdrawals"
    @pagy, @pending_withdrawals = pagy(Withdrawal.pending.includes(:account, :payment_method).order(id: :asc), items: 8)
  end

  def approved
    @title = "Approved Withdrawals"
    @pagy, @approved_withdrawals = pagy(Withdrawal.approved.includes(:account, :payment_method).order(id: :asc), items: 8)
  end

  def declined 
    @title = "Declined Withdrawals"
    @pagy, @declined_withdrawals = pagy(Withdrawal.declined.includes(:account, :payment_method).order(id: :asc), items: 8)
  end

  def show
    @title = "Withdrawal show"
    @withdrawal = Withdrawal.find(params[:id])
  end

  def approve
    @withdrawal = Withdrawal.find(params[:id])
    @withdrawal.update(status: 'approved')
    # account = @withdrawal.account
    # account.update(balance: account.balance + @withdrawal.amount)
    redirect_to admin_withdrawal_pending_path, notice: 'Withdrawal approved successfully.' # Redirect to the appropriate path after approval
  end

  def decline
    @withdrawal = Withdrawal.find(params[:id])
    @withdrawal.update(status: 'declined')
    account = @withdrawal.account
    account.update(balance: account.balance + @withdrawal.amount)
    redirect_to admin_withdrawal_pending_path, notice: 'Deposit declined successfully.' # Redirect to the appropriate path after decline
  end
end