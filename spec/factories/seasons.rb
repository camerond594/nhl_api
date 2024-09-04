FactoryBot.define do
  factory :season do
    after(:build) do |season|
      season.time_period ||= TimePeriod.find_or_create_by(
        name: "2023 - 2024 Season",
        start_date: "2023-01-01",
        end_date: "2024-01-01",
        year: "20232024"
      )
    end
  end
end