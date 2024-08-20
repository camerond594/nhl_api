class NhlApi::PullStats
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def record_stats(year:, player_ids:)
    player_ids.each do |player_id|
      player = Player.find_by(player_id: player_id)
      stats_response = @client.player_stats(player_id: player_id)
      season_totals = stats_response.dig("seasonTotals")

      season_totals.each do |season_total|
        team = Team.find_by(full_name: season_total.dig("teamName", "default"))
        next unless team
        season = TimePeriod.find_by(year: season_total["season"].to_s)&.season

        roster_assignment = RosterAssignment.joins(:roster)
          .where(player: player, rosters: { team_id: team.id, year: season_total["season"].to_s })
          .first

        if season_total["leagueAbbrev"] == "NHL" && team && roster_assignment
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
      end
    end
  end
end