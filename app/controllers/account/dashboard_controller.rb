class Account::DashboardController < AccountController
  def home
    @recent_trades = current_account.trades.includes(:currency_pair).order(id: :desc).limit(5)
    @recent_deposits = current_account.deposits.order(id: :desc).limit(5)
  end
end
