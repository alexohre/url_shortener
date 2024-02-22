class CurrencyPair < ApplicationRecord
  has_many :trades
  validates :base_currency, :quote_currency, presence: true
end
