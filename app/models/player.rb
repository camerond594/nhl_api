class Player < ApplicationRecord
  has_many :roster_assignments
  has_many :rosters, through: :roster_assignments
  has_many :player_stats, through: :roster_assignments

  scope :active, -> { where(active: true) }
  scope :skaters, -> { where.not(position: "G") }
  scope :goalies, -> { where(position: "G") }

  def current_roster
    roster_assignments.find_by(active: true)&.roster
  end

  def current_team
    roster_assignments.find_by(active: true)&.roster&.team
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def age
    ApplicationController.helpers.years_between(
      earlier_date: Date.parse(birth_date),
      later_date: Time.now
    )
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    %w[full_name total_games_played total_goals total_assists total_points]
  end

  def self.ransackable_associations(auth_object = nil)
    ["player_stats", "roster_assignments", "rosters"]
  end

  # If you want to allow sorting on certain attributes
  def self.ransackable_sortable_attributes(auth_object = nil)
    %w[full_name total_games_played total_goals total_assists total_points]
  end

  def self.summed_stat(stat_name:, game_type: "regular_season")
    Arel.sql(
      "COALESCE((
        SELECT SUM(player_stats.#{stat_name})
        FROM player_stats
        JOIN roster_assignments ON roster_assignments.id = player_stats.roster_assignment_id
        WHERE roster_assignments.player_id = players.id AND game_type = #{PlayerStat.game_types[game_type]}
        GROUP BY roster_assignments.player_id
      ), 0)"
    )
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||', parent.table[:first_name], parent.table[:last_name])
  end

  ransacker :total_games_played do |parent|
    summed_stat(stat_name: "games_played")
  end

  ransacker :total_goals do |parent|
    summed_stat(stat_name: "goals")
  end

  ransacker :total_assists do |parent|
    summed_stat(stat_name: "assists")
  end

  ransacker :total_points do |parent|
    summed_stat(stat_name: "points")
  end
end