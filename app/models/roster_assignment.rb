class RosterAssignment < ApplicationRecord
  belongs_to :player
  belongs_to :roster
  has_many :player_stats
  has_many :goalie_stats

  validates :player_id, uniqueness: { scope: :roster_id }
  validates :active, inclusion: { in: [true, false] }

  def team
    roster.team
  end
end