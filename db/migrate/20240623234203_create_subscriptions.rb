class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :plan
      t.decimal :montly_price
      t.decimal :yearly_price
      t.datetime :trial_ends_at

      t.timestamps
    end
  end
end
