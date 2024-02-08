class CurrencyPair < ApplicationRecord
  validates :base_currency, :quote_currency, presence: true
end
