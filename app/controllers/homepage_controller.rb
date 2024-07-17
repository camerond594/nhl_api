class HomepageController < ApplicationController
    def index
        binding.pry
        client = NhlApi::Client.new
        @rosters = []
        team_abbrevs.first(1).each do |team|
            @rosters << client.get_roster(team: team, year: "20212022")
        end
    end

    def team_abbrevs
        file = File.read(Rails.root.join("app", "models", "nhl_api", "teams_20232024.json"))
        teams = JSON.parse(file)
        teams["teams"].map { |team| team["abbreviation"] }
    end
end
