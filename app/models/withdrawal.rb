class Withdrawal < ApplicationRecord
  belongs_to :payment_method
  belongs_to :account

  enum status: { "Pending": 0, "Approved": 1, "Cancelled": 2 }
end
