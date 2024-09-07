require "rails_helper"

RSpec.describe Player, type: :model do
  let(:player) { create :player }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(player).to be_valid
    end

    it "is invalid without a first name" do
      player.first_name = nil
      expect(player).not_to be_valid
      expect(player.errors[:first_name]).to include("can't be blank")
    end

    it "is invalid without a last name" do
      player.last_name = nil
      expect(player).not_to be_valid
      expect(player.errors[:last_name]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "has many roster assignments" do
      expect(Player.reflect_on_association(:roster_assignments).macro).to eq(:has_many)
    end

    it "has many rosters through roster assignments" do
      expect(Player.reflect_on_association(:rosters).macro).to eq(:has_many)
    end
  end

  describe "Instance Methods" do
    let(:player) { create :player, :with_roster_assignments }
    let(:active_roster) { player.roster_assignments.find_by(active: true).roster }

    describe "#full_name" do
      it "returns the full name of the player" do
        player.first_name = "Wayne"
        player.last_name = "Gretzky"
        expect(player.full_name).to eq "Wayne Gretzky"
      end
    end

    describe "#current_team" do
      it "returns the current team of the player" do
        expect(player.current_team).to eq active_roster.team
      end
    end

    describe "#current_roster" do
      it "returns the current roster of the player" do
        expect(player.current_roster).to eq active_roster
      end
    end

    describe "#years_since_birth" do
      it "returns the current roster of the player" do
        expect(player.years_since_birth).to eq 54
      end
    end
  end
end
