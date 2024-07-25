class NhlApi::PullTeams
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def record_teams
    teams = @client.get_teams["data"]
    team_names = team_stat_ids
    teams.each do |team|
      Team.find_or_create_by({
        full_name: team["fullName"],
        common_name: team_names[team["fullName"]] ? team_names[team["fullName"]]["teamCommonName"] : "",
        place_name: team_names[team["fullName"]] ? team_names[team["fullName"]]["teamPlaceName"] : "",
        abbreviation: team["triCode"],
        slug: team["triCode"].downcase,
        league_id: team["leagueId"],
        franchise_id: team["franchiseId"],
      })
    end
  end

  private

  def team_stat_ids
    file = File.read(Rails.root.join("app", "models", "nhl_api", "team_stat_ids.json"))
    teams = JSON.parse(file)
    team_names = {}
    teams["data"].each { |team| team_names[team["fullName"]] = team }
    team_names
  end
end