class Recruiter < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  before_validation :email_downcase
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validate :password_complexity
  belongs_to :company, optional: true
  delegate :name, to: :company, prefix: true, allow_nil: true

  def email_downcase
    email&.strip&.downcase
  end

  def password_complexity
    complex_password = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/
    return unless password.present? && password !~ complex_password
    errors.add :password, 'Password must include at least one lowercase letter,
                           one uppercase letter, and one digit'
  end

  def skip_confirmation
    skip_confirmation!
  end
end
