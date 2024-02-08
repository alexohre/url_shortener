class CreateCurrencyPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_pairs do |t|
      t.string :base_currency
      t.string :quote_currency

      t.timestamps
    end
  end
end
