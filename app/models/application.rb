class Application < ApplicationRecord
  enum status: [ :pending, :opened, :contacted, :rejected ]

  belongs_to :match
  has_one :developer, through: :matches
  has_one :job, through: :matches
  has_one :company, through: :job
  validates :message, length: { maximum: 10000 }

end
