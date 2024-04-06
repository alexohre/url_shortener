class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :timeoutable, :trackable, :confirmable

  before_create :generate_username

  has_one_attached :avatar, dependent: :destroy

  validate :date_of_birth_must_be_past_18_years
  validates :first_name, :last_name, :username, :address, :state, :country, :gender, presence: true, unless: :new_record?

  has_many :urls, class_name: 'Url', foreign_key: 'account_id', dependent: :destroy
  
  private

  def date_of_birth_must_be_past_18_years
    if date_of_birth.present? && date_of_birth > 18.years.ago.to_date
      errors.add(:date_of_birth, "must be at least 18 years ago")
    end
  end
  
  def self.ransackable_attributes(auth_object = nil)
    %w[email first_name last_name]
  end

  def self.ransackable_associations(auth_object = nil)
    ["avatar_attachment", "avatar_blob"]
    # ["avatar_attachment", "avatar_blob", "deposits", "trades", "withdrawals"]
  end

  def generate_username
    # Split email at "@" and append 6 random characters
    prefix, domain = email.split('@')
    random_chars = SecureRandom.hex(3) # 6 random characters in hexadecimal form
    self.username = "#{prefix}_#{random_chars}"
  end
end
