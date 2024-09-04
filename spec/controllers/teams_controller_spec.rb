require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  render_views

  let(:roster) { create :roster, :with_players }
  let!(:team) { roster.team }

  describe "GET #index" do
    it "renders the teams list" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to include "NHL Teams"
      expect(response.body).to include "Team Name"
      expect(response.body).to include "Mighty Ducks"
    end
  end

  describe "GET #show" do
    it "renders the team show page" do
      get :show, params: { id: team.slug }

      expect(response).to have_http_status(:success)
      expect(response.body).to include "Mighty Ducks"
      expect(response.body).to include "Tricode: ANA"

      expect(response.body).to include "John Doe"
      expect(assigns(:skaters).count).to eq 5
      
      expect_player_stats
    end
  end

  def expect_player_stats
    expect(response.body).to include "GP"
    expect(response.body).to include "82"
    expect(response.body).to include "G"
    expect(response.body).to include "50"
    expect(response.body).to include "A"
    expect(response.body).to include "40"
    expect(response.body).to include "Pts"
    expect(response.body).to include "90"
    expect(response.body).to include "PIM"
    expect(response.body).to include "10"
  end
end