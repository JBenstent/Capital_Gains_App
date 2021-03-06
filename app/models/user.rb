class User < ActiveRecord::Base
  has_secure_password
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }, length: { in: 4..30 }

  validates :first_name, :last_name, :email, :city, :state, :zip, :phone, presence: true
  validates :password, presence: true, :on => :create

  has_many :transactions
end
