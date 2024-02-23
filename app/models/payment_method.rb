class PaymentMethod < ApplicationRecord
  has_one_attached :wallet_qrcode
  has_many :deposits

  validates :name, :wallet, presence: true
end
