FactoryBot.define do
  factory :player_stat do
    goals { 50 }
    assists { 40 }
    points { 90 }
    games_played { 82 }
    pim { 10 }
    plus_minus { -20 }

    association :season
  end
end