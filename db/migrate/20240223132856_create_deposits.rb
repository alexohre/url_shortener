class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.string :order_id
      t.string :amount
      t.integer :payment_method_id
      t.integer :status

      t.timestamps
    end
  end
end
