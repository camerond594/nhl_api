class RosterAssignment < ApplicationRecord
  belongs_to :player
  belongs_to :roster
  has_one :player_stat, required: false, dependent: :destroy
  has_one :goalie_stat, required: false, dependent: :destroy

  validates :player_id, uniqueness: { scope: :roster_id }
  validates :active, inclusion: { in: [true, false] }

  def team
    roster.team
  end
end