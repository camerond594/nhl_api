class Team < ApplicationRecord
  has_many :rosters, dependent: :destroy

  validates :full_name, presence: true
  validates :common_name, presence: true
  validates :place_name, presence: true

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