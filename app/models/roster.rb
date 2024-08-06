class Roster < ApplicationRecord
  belongs_to :team
  has_many :roster_assignments
  has_many :players, through: :roster_assignments

  def name
    year[0..3] + " - " + year[4..-1]
  end
end