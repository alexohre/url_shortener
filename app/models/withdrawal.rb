class Withdrawal < ApplicationRecord
  belongs_to :payment_method
  belongs_to :account

  enum status: { "pending": 0, "approved": 1, "declined": 2 }

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :declined, -> { where(status: :declined) }

  def self.ransackable_attributes(auth_object = nil)
    ["account_id", "address", "amount", "created_at", "id", "order_id", "payment_method_id", "status", "updated_at"]
  end
end
