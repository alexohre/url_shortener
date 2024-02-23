class Deposit < ApplicationRecord
  belongs_to :account
  belongs_to :payment_method
  has_one_attached :payment_proof

  enum status: { "Pending": 0, "Approved": 1, "Cancelled": 2 }
end
