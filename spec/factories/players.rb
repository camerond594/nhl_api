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

    trait :with_roster_assignments_and_stats do
      transient do
        active_year { "20202021" }  # Default year for active roster assignment
        inactive_years { ["20192020", "20182019"] }  # Default years for inactive assignments
      end

      after(:create) do |player, evaluator|
        # Create the active roster assignment with a player stat
        create(:roster_assignment, :with_player_stat, player: player, active: true, year: evaluator.active_year)
        
        # Create the inactive roster assignments with player stats for the given inactive years
        evaluator.inactive_years.each do |year|
          create(:roster_assignment, :with_player_stat, player: player, active: false, year: year)
        end
      end
    end
  end
end