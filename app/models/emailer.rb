class Emailer < ApplicationRecord
  has_rich_text :content
  validates :email, :subject, :content, presence: true
end
