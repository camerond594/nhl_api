class NhlApi::PullRosters
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def record_rosters(year:, teams: team_abbrevs)
    rosters = []

    teams.each do |team_abbrev|
      rosters << [@client.get_roster(team: team_abbrev, year: year), team_abbrev]
    end

    rosters.each do |roster_data, team_abbrev|
      player_ids = roster_data.values.flatten.map { |player| player["id"] }
      players = NhlApi::PullPlayers.new(client: @client).record_players(player_ids: player_ids)
      team = Team.find_by(abbreviation: team_abbrev)

      if year == "20232024"
        team.rosters.find_by(active: true)&.update(active: false)

        roster = Roster.find_or_create_by({
          year: year,
          team: team,
          active: true
        })
      else
        roster = Roster.find_or_create_by({
          year: year,
          team: team,
          active: false
        })
      end

      players.each do |player|
        if year == "20232024"
          player.roster_assignments.find_by(active: true)&.update(active: false)
          RosterAssignment.create(player: player, roster: roster, active: true)
        else
          RosterAssignment.create(player: player, roster: roster, active: false)
        end
      end
    end
  end

  private

  def team_abbrevs
    file = File.read(Rails.root.join("app", "models", "nhl_api", "teams_20232024.json"))
    teams = JSON.parse(file)
    teams["teams"].map { |team| team["abbreviation"] }
  end
end