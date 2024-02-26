class Emailer < ApplicationRecord
  validates :email, :subject, :content, presence: true
end
