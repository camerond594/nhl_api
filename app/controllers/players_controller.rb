class PlayersController < ApplicationController
  def index
    @players = Player.all.where(active: true)
  end

  def show
    @player = Player.find_by(slug: params[:id])
    not_found unless @player
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
