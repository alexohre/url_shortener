class PaymentMethod < ApplicationRecord
  has_one_attached :wallet_qrcode

  validates :name, :wallet, presence: true
end
