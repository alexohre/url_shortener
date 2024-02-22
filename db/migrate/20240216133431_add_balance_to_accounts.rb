class AddBalanceToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :balance, :decimal, precision: 10, scale: 2, default: 0.00
    add_column :accounts, :trade, :integer, default: 0
    add_column :accounts, :deposit, :integer, default: 0
    add_column :accounts, :withdrawal, :integer, default: 0
  end
end
