class Admin::DepositController < AdminController
  def pending
    @title = "Pending Deposit"
    @q = Deposit.pending.ransack(params[:q]) # Apply Ransack search to the pending scope
    @pagy, @pending_deposits = pagy(@q.result(distinct: true).includes(:account, :payment_method).order(id: :asc), items: 8)
  end


  def approved
    @title = "Approved Deposit"
    @q = Deposit.approved.ransack(params[:q])
    @pagy, @approved_deposits = pagy(@q.result(distinct: true).includes(:payment_method, :account).order(id: :desc), items: 8)
  end

  def declined 
    @title = "Declined Deposit"
    @q = Deposit.declined.ransack(params[:q])
    @pagy, @declined_deposits = pagy(@q.result(distinct: true).includes(:payment_method, :account).order(id: :desc), items: 8)

  end

  def show
    @deposit = Deposit.find(params[:id])
  end

  def approve
    @deposit = Deposit.find(params[:id])
    @deposit.update(status: 'approved')
    account = @deposit.account
    account.update(balance: account.balance + @deposit.amount)
    redirect_to admin_deposit_pending_path, notice: 'Deposit approved successfully.' # Redirect to the appropriate path after approval
  end

  def decline
    @deposit = Deposit.find(params[:id])
    @deposit.update(status: 'declined')
    redirect_to admin_deposit_pending_path, notice: 'Deposit declined successfully.' # Redirect to the appropriate path after decline
  end

end