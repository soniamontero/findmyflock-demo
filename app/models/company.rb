class Company < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :recruiters, dependent: :nullify
  has_many_attached :images
  has_one :subscriber, -> { order created_at: :desc }, dependent: :destroy

  validates :name, :url, presence: true, length: { maximum: 500 }

  def applications
    job_ids = jobs.pluck(:id)
    matches_ids = Match.where(job_id: job_ids).pluck(:id)
    Application.where(match_id: matches_ids)
  end

  def recruiters_mail
    self.recruiters.pluck(:email).flatten.uniq
  end

  def is_active?
    vetted? or (subscriber.present? and (
      subscriber.active? || (
        subscriber.canceled? && subscriber.subscription_expires_at >= Date.today
      )
    ))
  end

  def max_active_jobs
    case subscriber.try(:plan).try(:stripe_id)
    when "1-job"
      1
    when "3-jobs"
      3
    else
      1e6
    end
  end

  def can_add_job?
    is_active? and jobs.active.count < max_active_jobs
  end

  def is_member?
    subscriber.present? && (
      subscriber.active? || (
        subscriber.canceled? && subscriber.subscription_expires_at >= Date.today
      ) || subscriber.trialing? || subscriber.past_due?
    )
  end
end
