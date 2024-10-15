class PlayerStat < ApplicationRecord
  belongs_to :roster_assignment
  belongs_to :season
  attribute :game_type, :integer

  enum game_type: {
    preseason: 0,
    regular_season: 1,
    postseason: 2
  }

  scope :preseason, -> { where(game_type: :preseason) }
  scope :regular_season, -> { where(game_type: :regular_season) }
  scope :postseason, -> { where(game_type: :postseason) }

  scope :with_season_and_time_period, -> {
    joins(season: :time_period)
  }

  scope :with_player, -> {
    joins(roster_assignment: :player)
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      games_played
      goals
      assists
      points
      pim
      roster_id
      full_name
      position
      active_team_id
      active_player
      season_year
      years_since_birth
    ]
  end

  def self.ransackable_sortable_attributes(auth_object = nil)
    %w[
      games_played
      goals
      assists
      points
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["roster_assignment", "roster", "player", "season", "time_period"]
  end

  def self.ransackable_scopes(auth_object = nil)
    [:with_player, :with_season_and_time_period]
  end

  ransacker :roster_id do |parent|
    Arel.sql("(
      SELECT roster_id
      FROM roster_assignments
      WHERE roster_assignments.id = player_stats.roster_assignment_id
      LIMIT 1
    )")
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new(
      '||',
      Arel::Nodes::InfixOperation.new(
        '||',
        Player.arel_table[:first_name],
        Arel::Nodes.build_quoted(' ')
      ),
      Player.arel_table[:last_name]
    )
  end
  
  ransacker :season_year do
    query = <<-SQL
      (SELECT time_periods.year
       FROM time_periods
       INNER JOIN seasons ON seasons.time_period_id = time_periods.id
       WHERE seasons.id = player_stats.season_id)
    SQL

    Arel.sql(query)
  end

  ransacker :years_since_birth do
    query = <<-SQL
      EXTRACT(YEAR FROM AGE(CURRENT_DATE, players.birth_date))
    SQL

    Arel.sql(query)
  end

  # FIXME: For now, these are still included in the QueryBuilder search form so they
  # need to be here in order for the form to work. These should be removed and
  # the form should be altered.
  ransacker :position do |parent|
  end
  ransacker :active_team_id do |parent|
  end
  ransacker :active_player do |parent|
  end
end