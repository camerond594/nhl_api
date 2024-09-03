FactoryBot.define do
  factory :roster_assignment do
    association :roster
    association :player
    active { true }
  end
end