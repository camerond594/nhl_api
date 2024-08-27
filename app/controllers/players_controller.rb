class PlayersController < ApplicationController
  before_action :add_breadcrumbs

  def index
    @q = query
    @players = @q.result
    @players = @players.order(:last_name) if params[:q].blank?

    @players = @players.page(params[:page]).per(10)
  end

  def show
    @player = Player.find_by(slug: params[:id])
    @stats_by_year = @player.player_stats.group_by do |player_stat|
      player_stat.season.year
    end
    not_found unless @player
  end

  private

  def query
    if params[:goalies] == "true"
      Player.goalies.active.ransack(params[:q])
    elsif params[:skaters] == "true"
      Player.skaters.active.ransack(params[:q])
    else
      Player.active.ransack(params[:q])
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def add_breadcrumbs
    breadcrumbs.add "Players", players_path
  end
end
