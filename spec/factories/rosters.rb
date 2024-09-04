FactoryBot.define do
  factory :roster do
    year { "20232024" }
    association :team
    active { true }
  end

  trait :with_players do
    transient do
      player_count { 5 }
    end

    after(:create) do |roster, evaluator|
      create_list(:roster_assignment, evaluator.player_count, :with_player_stat, roster: roster)
    end
  end
end