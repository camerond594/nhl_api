require "rails_helper"

RSpec.describe HomepageController, type: :controller do
  render_views

  describe "GET #index" do
    it "renders the homepage" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response.body).to include("NHL API Visualized")
    end
  end
end