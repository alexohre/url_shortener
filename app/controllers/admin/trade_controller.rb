class Admin::TradeController < AdminController
  def active
    @title = "Active Trade"
    @q = Trade.active.ransack(params[:q])
    @pagy, @active_trades = pagy(@q.result(distinct: true).includes(:currency_pair, :account).order(id: :desc), items: 8)
  end

  def inactive
    @title = "Inactive Trade"
    @q = Trade.inactive.ransack(params[:q])
    @pagy, @inactive_trades = pagy(@q.result(distinct: true).includes(:currency_pair, :account).order(id: :desc), items: 8)
  end

  def destroy
    @trade = Trade.find(params[:id])
    if @trade.present?
      account = @trade.account
      account.update(trade: account.trade - 1)
      @trade.destroy
      redirect_to admin_trade_inactive_path, notice: "Trade deleted successfully"
    end
  end
end