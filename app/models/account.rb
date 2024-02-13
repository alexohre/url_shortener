class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :timeoutable, :trackable, :confirmable

  has_one_attached :avatar 
  # validates :first_name, :last_name, :username, presence: { on: :update }
end
