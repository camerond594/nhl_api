class NhlApi::PopulateData
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def populate(start_year:, end_year:)
    # TODO: We should be using an `active` column rather than a raw `count`.
    if Team.count < 32
      # We need all teams in place before we do anything else.
      NhlApi::PullTeams.new(client: @client).record_teams
    end

    # We want all seasons to be created beforehand.
    create_seasons

    years(start_year: start_year, end_year: end_year).each do |year, _|
      # This will create all Roster, Player, and RosterAssignment models for the given year.
      NhlApi::PullRosters.new(client: @client).record_rosters(year: year)
    end
  end

  private

  def create_seasons
    years(start_year: 1970, end_year: 2024).each do |year, start_year|
      time_period = TimePeriod.find_or_create_by(
        name: "#{start_year} - #{start_year + 1} Season",
        start_date: Date.new(start_year, 10, 1),
        year: year
      )
      Season.find_or_create_by(time_period: time_period)
    end
  end

  # This logic is needed since the way that the NHL models years
  # is in the format of 20212022 rather than having two separate fields.
  # Ex: years(start_year: 2021, end_year: 2024) will return
  #   ["20212022", "20222023", "20232024"].
  def years(start_year:, end_year:)
    year_counter = start_year
    years = []
    while year_counter < end_year
      years << ["#{year_counter}#{year_counter + 1}", year_counter]
      year_counter += 1
    end

    years
  end
end