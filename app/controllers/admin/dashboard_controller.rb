class Admin::DashboardController < AdminController
  def home
    @title = "Home"
    @total_acc = Account.count
    @total_trades = Trade.count
    @total_deposit = Deposit.count
    @total_withdrawal = Withdrawal.count
    @recent_deposits = Deposit.includes(:account, :payment_method).order(id: :desc).limit(5)
    @recent_withdrawals = Withdrawal.includes(:payment_method, :account).order(id: :desc).limit(5)
    @recent_trades = Trade.includes(:currency_pair, :account).order(id: :desc).limit(5)
  end

  def users
    @title = "Users"
    @pagy, @accounts = pagy(Account.includes(avatar_attachment: :blob).order(id: :desc), items: 8)
  end

  def show
    @account = Account.find(params[:id])
    @title = "#{@account.first_name.presence || @account.username}'s profile"
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.present?
      @account.destroy
      redirect_to admin_users_path, notice: "Account Deleted successfully!"
    end
  end
end
