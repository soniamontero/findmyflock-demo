class Match < ApplicationRecord
  has_one :application, dependent: :destroy
  belongs_to :developer
  belongs_to :job
  validates_uniqueness_of :developer_id, :scope => :job_id
  validate :match_is_valid?
  enum status: [
    'Uncontacted',
    'Contacted',
    'Interested',
    'Applied to role',
    'Sent to Google Hire',
    'Rejected'
  ]

  def match_is_valid?
    if !developer.matched_job.include?(job)
      errors.add :match, 'No match between developer requirement and job requirement. Impossible to save match'
    end
  end

end
