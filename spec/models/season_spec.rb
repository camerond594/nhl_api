require "rails_helper"

RSpec.describe Season, type: :model do
  let(:season) { create(:season) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(season).to be_valid
    end

    it "is invalid without a time period" do
      season.time_period = nil
      expect(season).not_to be_valid
      expect(season.errors[:time_period]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to a time period" do
      expect(Season.reflect_on_association(:time_period).macro).to eq(:belongs_to)
    end
  end

  describe "Instance Methods" do
    describe "#year" do
      it "returns the year range from the time period" do
        season.time_period.update(start_date: Date.new(2023, 1, 1), end_date: Date.new(2024, 1, 1))
        expect(season.year).to eq("2023 - 2024")
      end
    end
  end
end
