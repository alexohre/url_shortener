class Deposit < ApplicationRecord
  belongs_to :account
  belongs_to :payment_method
  has_one_attached :payment_proof, dependent: :destroy

  enum status: { "pending": 0, "approved": 1, "declined": 2 }

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :declined, -> { where(status: :declined) }

  def self.ransackable_attributes(auth_object = nil)
    ["account_id", "amount", "created_at", "id", "order_id", "payment_method_id", "status", "updated_at"]
  end

end
