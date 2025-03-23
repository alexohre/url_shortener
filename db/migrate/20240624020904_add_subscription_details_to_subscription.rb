class AddSubscriptionDetailsToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :billing_cycle, :string, default: 'monthly'
    add_column :subscriptions, :active_until, :datetime
  end
end
