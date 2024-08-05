class Team < ApplicationRecord
  has_many :rosters, dependent: :destroy

  def most_recent_roster
    current_roster || rosters.last
  end

  def current_roster
    rosters.find_by(active: true)
  end
end