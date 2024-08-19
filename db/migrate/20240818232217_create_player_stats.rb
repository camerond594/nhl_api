class CreatePlayerStats < ActiveRecord::Migration[7.1]
  def change
    create_table :player_stats do |t|
      t.references :roster_assignment, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true

      t.integer :points
      t.integer :assists
      t.integer :faceoff_win_pct
      t.integer :game_winning_goals
      t.integer :games_played
      t.integer :goals
      t.integer :ot_goals
      t.integer :pim
      t.integer :plus_minus
      t.integer :powerplay_goals
      t.integer :powerplay_points
      t.integer :shooting_pct
      t.integer :shorthanded_goals
      t.integer :shorthanded_points
      t.integer :shots
      t.string :avg_toi

      t.timestamps
    end
  end
end
