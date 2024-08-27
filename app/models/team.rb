class Team < ApplicationRecord
  has_many :rosters, dependent: :destroy

  scope :with_active_roster, -> { with_active_roster }

  def most_recent_roster
    current_roster || rosters.last
  end

  def current_roster
    rosters.find_by(active: true)
  end

  def self.with_active_roster
    joins(:rosters).where(rosters: { active: true }).distinct
  end
end