class NhlApi::PullPlayers
  def initialize(client: NhlApi::Client.new)
    @client = client
  end

  def record_players(player_ids:)
    players = []
    players_to_create = []
    created_players = []

    player_ids.each do |player_id|
      if player = Player.find_by(player_id: player_id)
        players << player 
      else
        players_to_create << @client.player_stats(player_id: player_id)
      end
    end
    
    players_to_create.each do |player|
      created_players << Player.find_or_create_by({
        player_id: player["playerId"],
        active: player["isActive"],
        current_team_id: player["currentTeamId"],
        first_name: player["firstName"]["default"],
        last_name: player["lastName"]["default"],
        sweater_number: player["sweaterNumber"],
        position: player["position"],
        headshot_url: player["headshot"],
        hero_image_url: player["heroImage"],
        height_in_inches: player["heightInInches"],
        height_in_centimeters: player["heightInCentimeters"],
        weight_in_pounds: player["weightInPounds"],
        weight_in_kilograms: player["weightInKilograms"],
        birth_date: Date.parse(player["birthDate"]),
        birth_city: player["birthCity"] ? player["birthCity"]["default"] : "",
        birth_state_province: player["birthStateProvince"] ? player["birthStateProvince"]["default"] : "",
        birth_country: player["birthCountry"],
        shoots_catches: player["shootsCatches"],
        slug: "#{player["firstName"]["default"]} #{player["lastName"]["default"]}".parameterize
      })
    end

    created_players + players
  end
end