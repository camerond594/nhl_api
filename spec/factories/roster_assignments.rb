FactoryBot.define do
  factory :roster_assignment do
    association :roster
    association :player
    active { true }

    trait :with_player_stat do
      transient do
        year { "20202021" }  # Default year if none is provided
      end

      after(:create) do |roster_assignment, evaluator|
        time_period = create(:time_period, year: evaluator.year)
        season = create(:season, time_period: time_period)
        create(:player_stat, roster_assignment: roster_assignment, season: season)
      end
    end
  end
end