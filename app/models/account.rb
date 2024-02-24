class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :timeoutable, :trackable, :confirmable

  has_one_attached :avatar 
  validate :date_of_birth_must_be_past_18_years
  validates :first_name, :last_name, :gender, :state, :country, :zip_code, :address, presence: { on: :update }

  has_many :trades
  has_many :deposits
  has_many :withdrawals

  private

  def date_of_birth_must_be_past_18_years
    if date_of_birth.present? && date_of_birth > 18.years.ago.to_date
      errors.add(:date_of_birth, "must be at least 18 years ago")
    end
  end
end
