FactoryBot.define do
  factory :player do
    first_name { "John" }
    last_name  { "Doe" }
    position   { "C" }
    slug { "john-doe" }
    birth_date { "1970-01-01" }
    player_id { 12345678 }
    headshot_url { "" }
    shoots_catches { "R" }
    birth_city { "Victoria" }
    birth_country { "Canada" }

    trait :goalie do
      position { "G" }
    end

    trait :with_roster_assignment do
      after(:create) do |player|
        create(:roster_assignment, player: player, active: true)
      end
    end

    trait :with_player_stat do
      with_roster_assignment

      after(:create) do |player|
        create(:player_stat, roster_assignment: player.roster_assignments.first)
      end
    end
  end
end