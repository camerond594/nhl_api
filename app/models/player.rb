class Player < ApplicationRecord
  has_many :roster_assignments
  has_many :rosters, through: :roster_assignments
  has_many :player_stats, through: :roster_assignments
  has_many :goalie_stats, through: :roster_assignments

  scope :active, -> { where(active: true) }
  scope :skaters, -> { where.not(position: "G") }
  scope :goalies, -> { where(position: "G") }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def current_roster
    roster_assignments.find_by(active: true)&.roster
  end

  def current_team
    roster_assignments.find_by(active: true)&.roster&.team
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def years_since_birth
    ApplicationController.helpers.years_between(
      earlier_date: birth_date,
      later_date: Time.now
    )
  end

  def stats_for_season(year:)
    player_stats.joins(season: :time_period)
      .where(time_periods: { year: year })
  end

  private

  def self.ransackable_attributes(auth_object = nil)
    %w[
      full_name
      total_games_played
      total_goals
      total_assists
      total_points
      total_pim
      games_played
      goals
      assists
      points
      position
      active_team_id
      active_player
      years_since_birth
      season_year
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["player_stats", "roster_assignments", "rosters", "seasons", "teams"]
  end

  # If you want to allow sorting on certain attributes
  def self.ransackable_sortable_attributes(auth_object = nil)
    %w[
      full_name
      total_games_played
      total_goals
      total_assists
      total_points
      games_played
      goals
      assists
      points
    ]
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

  ransacker :total_pim do |parent|
    summed_stat(stat_name: "pim")
  end

  ransacker :active_team_id do
    Arel.sql(
      <<-SQL
        (SELECT team_id FROM rosters
         JOIN roster_assignments ON rosters.id = roster_assignments.roster_id
         WHERE roster_assignments.player_id = players.id AND rosters.active = true
         LIMIT 1)
      SQL
    )
  end

  ransacker :active_player do
    Arel.sql(
      <<-SQL
        (
          EXISTS (
            SELECT 1
            FROM roster_assignments
            JOIN rosters ON roster_assignments.roster_id = rosters.id
            WHERE roster_assignments.player_id = players.id
              AND roster_assignments.active = true
              AND rosters.active = true
          )
        )
      SQL
    )
  end

  ransacker :years_since_birth do
    Arel.sql("EXTRACT(YEAR FROM AGE(players.birth_date))")
  end

  ransacker :season_year do |parent|
    Arel.sql("(SELECT time_periods.year
      FROM time_periods
      INNER JOIN seasons ON seasons.time_period_id = time_periods.id
      INNER JOIN player_stats ON player_stats.season_id = seasons.id
      INNER JOIN roster_assignments ON roster_assignments.id = player_stats.roster_assignment_id
      WHERE roster_assignments.player_id = players.id
      LIMIT 1)")
  end
end