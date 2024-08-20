class PlayerStat < ApplicationRecord
  belongs_to :roster_assignment
  belongs_to :season
  attribute :game_type, :integer

  enum game_type: {
    preseason: 0,
    regular_season: 1,
    postseason: 2
  }

  scope :preseason, -> { where(game_type: :preseason) }
  scope :regular_season, -> { where(game_type: :regular_season) }
  scope :postseason, -> { where(game_type: :postseason) }
end