class Job < ApplicationRecord
  belongs_to :company
  has_many :matches, dependent: :destroy
  has_many :skills, as: :skillable, dependent: :destroy
  has_many :developers, through: :matches
  has_many :applications, through: :matches
  validates :title, presence: true,  length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 10000 }
  validates :city, :state, :country, presence: true,  length: { maximum: 100 }
  validates :max_salary, numericality: { only_integer: true, greater_than: 0}, :allow_nil => true
  validates :remote, inclusion: { in: [["remote"], ["office"], ["remote", "office"]]}
  validates :employment_type, presence: true, length: { maximum: 100 }
  validates :benefits, length: { minimum: 1 }, on: :update
  geocoded_by :location
  before_validation :geocode
  validate :check_cordinates, on: [:create, :update]

  before_validation :sanitaze_benefits_cultures

  scope :active, -> { where(active: true) }
  scope :check_location, -> (miles, lat, long) {
    if lat.present?
      geocoded.near([lat, long], miles, units: :mi, :order => nil)
    else
      all
    end
  }
  scope :remote_or_office_jobs, -> (array) {where("remote <@ ARRAY[?]::text[] OR remote @> ARRAY[?]::text[]", array, array)}
  scope :can_sponsor, -> {where("can_sponsor = true")}
  scope :match_skills_type, -> (array) { where.not(skills_array: []).where("skills_array <@ ARRAY[?]::text[]", array) }
  scope :filter_by_salary, -> (value) {where("max_salary >= ?", value)}
  scope :filter_by_benefits, -> (array) { where("benefits @> ARRAY[?]::text[]", array) }
  scope :filter_by_cultures, -> (array) { where("cultures @> ARRAY[?]::text[]", array) }
  scope :filter_by_employment_type, -> (value) { where("employment_type = ?", value) }
  scope :filter_by_city, -> (array) { where(city: array)}
  scope :order_by_vetted, -> { order(vetted: :desc) }

  scope :local_office, -> (miles, lat, long) {
    where("'office' = ANY (remote)").check_location(miles, lat, long)
  }
  scope :all_remote, -> { where("'remote' = ANY (remote)") }

  def location
    [city, zip_code, state, country].compact.join(', ')
  end

  def deactivate
    self.active = false
  end

  def sanitaze_benefits_cultures
    benefits.reject!(&:empty?)
    cultures.reject!(&:empty?)
  end

  def check_cordinates
    errors.add(:city, "There is a problem with your location. Please try again") if latitude.nil?
  end

  def toggle_to_vetted
    if company.vetted?
      self.vetted = true
    end
  end

end
