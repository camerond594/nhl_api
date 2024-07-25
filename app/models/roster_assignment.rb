class RosterAssignment < ApplicationRecord
  belongs_to :player
  belongs_to :roster

  validates :player_id, uniqueness: { scope: :roster_id }
  validates :active, inclusion: { in: [true, false] }
end