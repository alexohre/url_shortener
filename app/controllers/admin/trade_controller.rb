class Admin::TradeController < AdminController
  def active
    @title = "Active Trade"
    @pagy, @active_trades = pagy(Trade.active.includes(:currency_pair, :account).order(id: :desc), items: 8)
  end

  def inactive
    @title = "Inactive Trade"
    @pagy, @inactive_trades = pagy(Trade.inactive.includes(:currency_pair, :account).order(id: :desc), items: 8)
  end
end