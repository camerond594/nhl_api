require "rails_helper"

RSpec.describe PlayersController, type: :controller do
  render_views

  let!(:player) { create :player, :with_player_stat }

  describe "GET #index" do
    it "renders the players list" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to include "NHL Players"
      expect(response.body).to include "Player Name"
      expect(response.body).to include "John Doe"
      expect(response.body).to include "Position"
      expect(response.body).to include "C"
      expect(response.body).to include "Years since birth"
      expect(response.body).to include "54"

      expect_player_stats
    end
  end

  describe "GET #show" do
    it "renders the player show page" do
      get :show, params: { id: player.slug }

      expect(response).to have_http_status(:success)
      expect(response.body).to include "John Doe"
      expect(response.body).to include "Position: C"
      expect(response.body).to include "Shoots/Catches: R"
      expect(response.body).to include "Born: 1970-01-01 -- Victoria, Canada"
      expect(response.body).to include "[54 years ago]"

      expect(response.body).to include "Season"
      expect(response.body).to include "2023 - 2024"
      expect(response.body).to include "Team"
      expect(response.body).to include "Mighty Ducks"
      expect(response.body).to include "League"
      expect(response.body).to include "NHL"

      expect_player_stats

      expect(response.body).to include "+/-"
      expect(response.body).to include "-20"
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