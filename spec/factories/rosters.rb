FactoryBot.define do
  factory :roster do
    year { "20232024" }
    association :team
  end

  trait :with_players do
    transient do
      player_count { 5 }
    end

    after(:create) do |roster, evaluator|
      create_list(:roster_assignment, evaluator.player_count, roster: roster)
    end
  end
end