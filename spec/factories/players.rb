FactoryBot.define do
  factory :player do
    first_name { "John" }
    last_name  { "Doe" }
    position   { "C" }

    trait :goalie do
      position { "G" }
    end

    trait :with_roster_assignment do
      after(:create) do |player|
        create(:roster_assignment, player: player, active: true)
      end
    end
  end
end