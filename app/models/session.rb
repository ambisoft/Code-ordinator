class Session
  include ActiveModel::Model

  attr_accessor :password
  attr_reader :email
  attr_writer :user

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, presence: true, if: -> { user.blank? }
  validate :existence, if: -> { email.present? }
  validate :authenticity, if: -> { user.present? }
  delegate :id, :authenticate, to: :user, allow_nil: true

  def email=(email)
    @email = email
  end

  def user
    @user = User.find_by_email(email)
  end

  private
  def existence
    errors.add(:email, :invalid) if user.blank?
  end

  def authenticity
    errors.add(:password, :invalid) unless authenticate(password)
  end
end