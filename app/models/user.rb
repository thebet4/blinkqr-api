class User < ApplicationRecord
  has_secure_password
  has_many :links

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, length: { minimum: 6 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
