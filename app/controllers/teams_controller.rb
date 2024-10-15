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

    @q = PlayerStat.regular_season.ransack(query_params)
    @skater_stats = @q.result.includes(:roster_assignment)
    @goalies = @roster.players.goalies
  end

  private

  def query_params
    params[:q] ||= {}
    params[:q][:roster_id_eq] = @roster.id
    params[:q]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def add_breadcrumbs
    breadcrumbs.add "Teams", teams_path
  end
end
