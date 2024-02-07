class Site < ApplicationRecord
  validates :contact_number, :contact_email, :contact_address, presence: true
end
