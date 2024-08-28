class NhlApi::PullStats
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def record_stats(player_ids:)
    player_ids.each do |player_id|
      player = Player.find_by(player_id: player_id)
      stats_response = @client.player_stats(player_id: player_id)
      season_totals = stats_response.dig("seasonTotals")

      next unless season_totals

      season_totals.each do |season_total|
        team = Team.find_by(full_name: season_total.dig("teamName", "default"))
        next unless team
        season = TimePeriod.find_by(year: season_total["season"].to_s)&.season

        roster_assignment = RosterAssignment.joins(:roster)
          .where(player: player, rosters: { team_id: team.id, year: season_total["season"].to_s })
          .first

        if season_total["leagueAbbrev"] == "NHL" && team && roster_assignment
          create_stat(
            roster_assignment: roster_assignment,
            season: season,
            season_total: season_total,
            position: player.position
          )
        end
      end
    end
  end

  private

  def create_stat(roster_assignment:, season:, season_total:, position:)
    if position == "G"
      create_goalie_stat(roster_assignment: roster_assignment, season: season, season_total: season_total)
    else
      create_player_stat(roster_assignment: roster_assignment, season: season, season_total: season_total)
    end
  end

  def create_player_stat(roster_assignment:, season:, season_total:)
    PlayerStat.find_or_create_by(
      roster_assignment: roster_assignment,
      season: season,
      game_type: season_total["gameTypeId"] - 1,
      points: season_total["points"],
      goals: season_total["goals"],
      assists: season_total["assists"],
      faceoff_win_pct: season_total["faceoffWinningPctg"],
      game_winning_goals: season_total["gameWinningGoals"],
      games_played: season_total["gamesPlayed"],
      ot_goals: season_total["otGoals"],
      pim: season_total["pim"],
      plus_minus: season_total["plusMinus"],
      powerplay_goals: season_total["powerPlayGoals"],
      powerplay_points: season_total["powerPlayPoints"],
      shooting_pct: season_total["shootingPctg"],
      shorthanded_goals: season_total["shorthandedGoals"],
      shorthanded_points: season_total["shorthandedPoints"],
      shots: season_total["shots"],
      avg_toi: season_total["avgToi"]
    )
  end

  def create_goalie_stat(roster_assignment:, season:, season_total:)
    GoalieStat.find_or_create_by(
      roster_assignment: roster_assignment,
      season: season,
      game_type: season_total["gameTypeId"] - 1,
      assists: season_total["assists"],
      games_played: season_total["gamesPlayed"],
      games_started: season_total["gamesStarted"],
      goals: season_total["goals"],
      goals_against: season_total["goalsAgainst"],
      goals_against_average: season_total["goalsAgainstAvg"],
      wins: season_total["wins"],
      losses: season_total["losses"],
      ot_losses: season_total["otLosses"],
      pim: season_total["pim"],
      save_percentage: season_total["savePctg"],
      shots_against: season_total["shotsAgainst"],
      shutouts: season_total["shutouts"],
      time_on_ice: season_total["timeOnIce"],
    )
  end
end