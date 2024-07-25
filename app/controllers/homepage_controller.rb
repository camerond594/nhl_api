class HomepageController < ApplicationController
    def index
        @rosters = Roster.all.where(active: true)
    end

    def team_abbrevs
        file = File.read(Rails.root.join("app", "models", "nhl_api", "teams_20232024.json"))
        teams = JSON.parse(file)
        teams["teams"].map { |team| team["abbreviation"] }
    end
end
