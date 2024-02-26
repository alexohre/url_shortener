class Withdrawal < ApplicationRecord
  belongs_to :payment_method
  belongs_to :account

  enum status: { "pending": 0, "approved": 1, "declined": 2 }

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :declined, -> { where(status: :declined) }
end
