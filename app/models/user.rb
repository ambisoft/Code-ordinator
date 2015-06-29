class User < ActiveRecord::Base
    has_many :notes, dependent: :destroy

    before_create :create_token, on: :create
    before_validation :create_temp_password, on: :create

    validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
    validates :email, uniqueness: { case_sensitive: false }, on: :create
    validates :password, length: { minimum: 7 }, confirmation: true, allow_nil: true
    has_secure_password

    private
    def create_token
        token = nil
        loop do
            token = SecureRandom.uuid
            break unless User.exists?(activation_token: token)
        end
        self.activation_token = token
    end
    def create_temp_password # just some fucked up shit with has_secure_password...
        self.password_confirmation = self.password = SecureRandom.uuid
    end
end
