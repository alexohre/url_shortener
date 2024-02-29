class Admin::WithdrawalController < AdminController
  def pending
    @title = "Pending Withdrawals"
    @q = Withdrawal.pending.ransack(params[:q])
    @pagy, @pending_withdrawals = pagy(@q.result(distinct: true).includes(:account, :payment_method).order(id: :asc), items: 8)
  end

  def approved
    @title = "Approved Withdrawals"
    @q = Withdrawal.approved.ransack(params[:q])
    @pagy, @approved_withdrawals = pagy(@q.result(distinct: true).includes(:account, :payment_method).order(id: :asc), items: 8)
  end

  def declined 
    @title = "Declined Withdrawals"
    @q = Withdrawal.declined.ransack(params[:q])
    @pagy, @declined_withdrawals = pagy(@q.result(distinct: true).includes(:account, :payment_method).order(id: :asc), items: 8)
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