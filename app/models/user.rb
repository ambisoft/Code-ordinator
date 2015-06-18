class User < ActiveRecord::Base
  has_many :notes, dependent: :destroy

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates :password, length: { minimum: 7 }
  has_secure_password
end
