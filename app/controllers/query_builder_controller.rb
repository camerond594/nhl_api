class QueryBuilderController < ApplicationController
  before_action :add_breadcrumbs

  def index
    if (year = query_params[:season_year_eq].present?)
      @q = PlayerStat.regular_season.with_player.with_season_and_time_period.ransack(query_params)
      @season = TimePeriod.find_by(year: year)&.season
      @skater_stats = @q.result.page(params[:page]).per(params[:per_page] || 25)
    else
      @q = Player.ransack(query_params)
      @season = nil
      @players = @q.result
      @players = @players.page(params[:page]).per(params[:per_page] || 25)
    end
  end

  private

  def query_params
    params[:q] ||= {}
  end

  def add_breadcrumbs
    breadcrumbs.add "Query Builder", query_builder_path
  end

  def query_params
    default_params = params[:q] || {}
    default_params[:active_player_eq] = true if default_params.empty?
    default_params
  end
end
