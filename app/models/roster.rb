class Roster < ApplicationRecord
  belongs_to :team
  has_many :roster_assignments
  has_many :players, through: :roster_assignments
end