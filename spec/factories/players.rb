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

    trait :with_roster_assignments do
      after(:create) do |player|
        create(:roster_assignment, player: player, active: true)
        create(:roster_assignment, player: player, active: false)
        create(:roster_assignment, player: player, active: false)
      end
    end
  end
end