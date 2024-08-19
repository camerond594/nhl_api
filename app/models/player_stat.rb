class PlayerStat < ApplicationRecord
  belongs_to :roster_assignment
  belongs_to :season
end