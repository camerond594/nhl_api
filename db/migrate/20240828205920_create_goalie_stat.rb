class CreateGoalieStat < ActiveRecord::Migration[7.1]
  def change
    create_table :goalie_stats do |t|
      t.references :roster_assignment, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true

      # See: GoalieStat model for game_type enum.
      t.integer :game_type, null: false, default: 1

      t.integer :assists
      t.integer :games_played
      t.integer :games_started
      t.integer :goals
      t.integer :goals_against
      t.float :goals_against_average
      t.integer :wins
      t.integer :losses
      t.integer :ot_losses
      t.integer :pim
      t.float :save_percentage
      t.integer :shots_against
      t.integer :shutouts
      t.integer :time_on_ice

      t.timestamps
    end
  end
end
