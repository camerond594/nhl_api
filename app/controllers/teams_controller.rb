class TeamsController < ApplicationController
  def index
    @teams = Team.all.page(params[:page]).per(25)
  end

  def show
    @team = Team.find_by(slug: params[:id])
    not_found unless @team
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
