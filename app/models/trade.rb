class Trade < ApplicationRecord
  belongs_to :account
  belongs_to :currency_pair
  enum time_duration: { "1 Min": 1, "5 Mins": 5, "10 Mins": 10, "15 Mins": 15, "30 Mins": 30, "1 Hr": 60, "3 Hrs": 180, "12 Hrs": 720, "1 Day": 1440 }
  enum status: { "running": 0, "completed": 1, "cancelled": 2 }

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 10, message: "must be at least $10" }

  scope :active, -> { where(status: :running) }
  scope :inactive, -> { where(status: [:completed, :cancelled]) }

  def self.ransackable_attributes(auth_object = nil)
    ["account_id", "account_type", "amount", "created_at", "currency_pair_id", "id", "job_id", "order_id", "profit_loss", "status", "time_duration", "trade_type", "updated_at"]
  end

end
