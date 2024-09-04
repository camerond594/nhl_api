FactoryBot.define do
  factory :roster_assignment do
    association :roster
    association :player
    active { true }

    trait :with_player_stat do
      after(:create) do |roster_assignment|
        create(:player_stat, roster_assignment: roster_assignment)
      end
    end
  end
end