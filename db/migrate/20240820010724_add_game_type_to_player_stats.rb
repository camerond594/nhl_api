class AddGameTypeToPlayerStats < ActiveRecord::Migration[7.1]
  def change
    add_column :player_stats, :game_type, :integer, null: false, default: 1
  end
end
