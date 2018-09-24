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
    Company.all.each do |company|
      @applications_array = []
      emails_to_send = 0
      company.applications.where(status: ["pending", "opened"]).each do |app|
        if ((Time.now - app.last_mail_sent) / 1.day) >= 7
          @applications_array << app
          emails_to_send =+ 1
        end
      end
      if emails_to_send.positive?
        CompanyMailer.application_reminder(@applications_array).deliver
        # @applications_array.each do |app|
        #   app.update_attribute(:last_mail_sent, Time.now)
        # end
      end
    end
  end
end

