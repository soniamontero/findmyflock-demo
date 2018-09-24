class Application < ApplicationRecord
  enum status: [ :pending, :opened, :contacted, :rejected ]

  belongs_to :match
  has_one :developer, through: :matches
  has_one :job, through: :matches
  has_one :company, through: :job
  validates :message, length: { maximum: 8000 }

  scope :open, -> { where.not(status: :rejected) }

  delegate :job, :developer, to: :match, allow_nil: true
  delegate :company, to: :job, allow_nil: true
  delegate :recruiters_mail, to: :company, allow_nil: true

  def self.reminder
    applications_array = []
    byebug
    new_reminders = 0
    all.where(status: ["pending", "opened"]).each do |app|
      if ((app.updated_at - app.created_at) / 1.day) >= 7
        new_reminders =+ 1
        applications_array << app
      end
    end
    if new_reminders.positive?
      applications_array.each do |app|
        if app.last_mail_sent == nil || ((Time.now - app.last_mail_sent) / 1.day) >= 7
          application_id = app.id
          CompanyMailer.application_reminder(application_id).deliver
          app.last_mail_sent == Time.now
        end
      end
    end
  end
end
