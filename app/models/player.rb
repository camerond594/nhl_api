class Player < ApplicationRecord
  has_many :roster_assignments
  has_many :rosters, through: :roster_assignments
  has_many :player_stats, through: :roster_assignments

  scope :active, -> { where(active: true) }

  def current_roster
    roster_assignments.find_by(active: true)&.roster
  end

  def current_team
    roster_assignments.find_by(active: true)&.roster&.team
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[full_name]
  end

  # If you want to allow sorting on certain attributes
  def self.ransackable_sortable_attributes(auth_object = nil)
    %w[full_name first_name last_name position]
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], parent.table[:last_name])
  end
end