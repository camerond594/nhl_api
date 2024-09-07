require "rails_helper"

RSpec.describe Roster, type: :model do
  let(:roster) { create(:roster) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(roster).to be_valid
    end

    it "is invalid without a year" do
      roster.year = nil
      expect(roster).not_to be_valid
      expect(roster.errors[:year]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to a team" do
      expect(roster).to belong_to(:team)
    end

    it "has many roster assignments" do
      expect(roster).to have_many(:roster_assignments).dependent(:destroy)
    end
  end

  describe "Instance Methods" do
    describe "#players" do
      let(:player) { create :player }

      before { create(:roster_assignment, roster: roster, player: player, active: true) }

      it "returns all players associated with the roster through roster assignments" do
        expect(roster.players).to include player
      end
    end

    describe "#grouped_roster" do
      let(:roster) { create :roster, :with_players }

      before do
        roster.players.first.update(position: "D")
        roster.players.second.update(position: "D")
        roster.players.third.update(position: "R")
        roster.players.fourth.update(position: "C")
        roster.players.fifth.update(position: "L")
      end

      it "groups the roster according to position" do
        expect(roster.grouped_roster.map(&:position)).to eq ["L", "C", "R", "D", "D"]
      end
    end
  end
end
