class QueryBuilderController < ApplicationController
  before_action :add_breadcrumbs

  def index
    @q = Player.ransack(query_params)
    @players = @q.result
    @players = @players.page(params[:page]).per(params[:per_page] || 25)
  end

  private

  def add_breadcrumbs
    breadcrumbs.add "Query Builder", query_builder_path
  end

  def query_params
    default_params = params[:q] || {}
    default_params[:active_player_eq] = true if default_params.empty?
    default_params
  end
end
