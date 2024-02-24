class CreateWithdrawals < ActiveRecord::Migration[7.0]
  def change
    create_table :withdrawals do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.references :payment_method, null: false, foreign_key: true
      t.text :address
      t.integer :status
      t.references :account, null: false, foreign_key: true
      t.string :order_id

      t.timestamps
    end
  end
end
