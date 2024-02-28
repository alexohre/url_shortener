class PaymentMethod < ApplicationRecord
  has_one_attached :wallet_qrcode, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :withdrawals, dependent: :destroy

  validates :name, :wallet, presence: true
end
