class Admin::DashboardController < AdminController
  def home
    @title = "Home"
    @total_acc = Account.count
    @total_trades = Trade.count
    @recent_trades = Trade.includes(:currency_pair, :account).order(id: :desc).limit(5)
  end

  def users
    @title = "Users"
    @pagy, @accounts = pagy(Account.order(id: :desc), items: 8)
  end
end
