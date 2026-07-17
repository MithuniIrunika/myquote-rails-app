class User < ApplicationRecord
  has_secure_password
  has_many :quotes, dependent: :destroy

  validates :fname, presence: { message: "First name cannot be blank" },
                    length: { maximum: 50 }
  validates :lname, presence: { message: "Last name cannot be blank" },
                    length: { maximum: 50 }
  validates :email, presence: { message: "Email address cannot be blank" },
                    uniqueness: { case_sensitive: false,
                                  message: "is already registered" },
                    format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: "must be a valid email address" }
  validates :password, length: { minimum: 6,
                                 message: "must be at least 6 characters long" },
                       if: -> { new_record? || !password.nil? }
  validates :status, presence: true,
                     inclusion: { in: %w[Active Suspended Banned],
                                  message: "must be Active, Suspended or Banned" }

  before_save { self.email = email.downcase if email.present? }
  after_initialize :set_default_status, if: :new_record?

  def full_name
    "#{fname} #{lname}"
  end

  private

  def set_default_status
    self.status ||= "Active"
    self.is_admin = false if is_admin.nil?
  end
end