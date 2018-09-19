class Match < ApplicationRecord
  has_one :application, dependent: :destroy
  belongs_to :developer
  belongs_to :job
  validates_uniqueness_of :developer_id, :scope => :job_id
  validate :match_is_valid?

  delegate :status, to: :application, prefix: true, allow_nil: true
  delegate :full_name, to: :developer
  delegate :company_name, :company_url, :title, to: :job

  def match_is_valid?
    if !developer.matched_job.include?(job)
      errors.add :match, 'No match between developer requirement and job requirement. Impossible to save match'
    end
  end
end
