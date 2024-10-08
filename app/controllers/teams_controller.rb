class TeamsController < ApplicationController
  before_action :add_breadcrumbs

  def index
    @teams = Team.with_active_roster
      .order(:full_name)
      .page(params[:page])
      .per(32)
  end

  def show
    @team = Team.find_by(slug: params[:id].downcase)
    @rosters = @team.rosters.order(year: :desc)
    @roster = Roster.find_by(id: params[:roster_id]) || @team.most_recent_roster
   
    not_found unless @team && @roster

    @skaters = @roster.grouped_roster.skaters
    @q = @skaters.ransack(params[:q])
    @skaters = @q.result

    @goalies = @roster.players.goalies
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def add_breadcrumbs
    breadcrumbs.add "Teams", teams_path
  end
end
