class Player < ApplicationRecord
  has_many :roster_assignments
  has_many :rosters, through: :roster_assignments
  has_many :player_stats, through: :roster_assignments

  def current_roster
    roster_assignments.find_by(active: true)&.roster
  end

  def current_team
    roster_assignments.find_by(active: true)&.roster&.team
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end