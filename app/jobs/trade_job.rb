class TradeJob < ApplicationJob
  queue_as :default

  def perform(trade_id)
    trade = Trade.find(trade_id)
    account = trade.account
    # Update trade status to completed
    trade.update(status: :completed)

    # Calculate profit/loss based on trade outcome
    outcome = rand(0..1) # Simulate trade outcome randomly
    if outcome.zero?
      profit_loss = 0 # If the outcome is 0, profit/loss is $0.00
    else
      # Generate a random percentage for profit/loss
      random_percent = rand(1..50)
      # Calculate profit/loss based on the random percentage
      profit = trade.amount * random_percent / 100.0

      profit_loss = profit + trade.amount
    end

    # Update profit/loss in the trade record
    trade.update(profit_loss: profit_loss )

    account.update(balance: account.balance + profit_loss)
  end
end
