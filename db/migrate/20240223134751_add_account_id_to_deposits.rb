class AddAccountIdToDeposits < ActiveRecord::Migration[7.0]
  def change
    add_column :deposits, :account_id, :integer
    add_index :deposits, :account_id
  end
end
