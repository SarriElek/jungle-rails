class User < ActiveRecord::Base

  has_secure_password

  has_many :reviews

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, too_short: "%{count} characters is the minimum allowed" }, confirmation: { case_sensitive: false }
  validates :password_confirmation, presence: true

  def self.authenticate_with_credentials(email, password)
    email.strip!
    user = User.where("lower(email) LIKE lower(?)", email).first
    user.authenticate(password) ? user : nil
  end

end
