require "rails_helper"

RSpec.describe Team, type: :model do
  let(:roster) { create :roster, :with_players }
  let(:team) { roster.team }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(team).to be_valid
    end

    it "is invalid without a full name" do
      team.full_name = nil
      expect(team).not_to be_valid
      expect(team.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without a common name" do
      team.common_name = nil
      expect(team).not_to be_valid
      expect(team.errors[:common_name]).to include("can't be blank")
    end

    it "is invalid without a place name" do
      team.place_name = nil
      expect(team).not_to be_valid
      expect(team.errors[:place_name]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "has many rosters" do
      expect(Team.reflect_on_association(:rosters).macro).to eq(:has_many)
    end
  end

  describe "Instance Methods" do
    describe "#current_roster" do
      subject { team.current_roster }

      describe "if there is multiple rosters and one is active" do
        let(:inactive_roster) { create(:roster, team: team, active: false) }

        it { is_expected.to eq roster }
      end

      describe "if there are no available rosters" do
        before { team.rosters.destroy_all }

        it { is_expected.to be_nil }
      end
    end

    describe "#most_recent_roster" do
      subject { team.most_recent_roster }

      let(:inactive_roster) { create(:roster, team: team, active: false) }

      describe "if there is an active roster" do
        it { is_expected.to eq roster }
      end

      describe "if there is not an active roster" do
        before { roster.update(active: false) }

        # Note that this isn't the greatest functionality, but it's simply a failsafe for now.
        # This will hypothetically only occur for teams that are defunct (e.g. Atlanta Thrashers).
        it { is_expected.to eq roster }
      end
    end
  end
end
