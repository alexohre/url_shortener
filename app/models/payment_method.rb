class PaymentMethod < ApplicationRecord
  has_one_attached :wallet_qrcode
  has_many :deposits
  has_many :withdrawals

  validates :name, :wallet, presence: true
end
