FactoryBot.define do
  factory :time_period do
    year { "20232024" }
    sequence(:start_date) { |n| "2023-01-01-#{n}" }
    sequence(:name) { |n| "Season #{n}" }
    end_date { "2024-01-01" }
  end
end