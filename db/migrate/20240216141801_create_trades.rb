class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    create_table :trades do |t|
      t.integer :currency_pair_id
      t.decimal :amount, precision: 10, scale: 2, default: 0.00
      t.decimal :profit_loss, precision: 10, scale: 2, default: 0.00
      t.integer :time_duration
      t.string :trade_type
      t.string :account_type
      t.string :order_id
      t.integer :status
      t.integer :account_id

      t.timestamps
    end
  end
end
