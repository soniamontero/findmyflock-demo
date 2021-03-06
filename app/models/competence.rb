class Competence < ApplicationRecord
  validates :value, presence: true, length: { maximum: 30 }
  default_scope { order('value ASC') }
end
