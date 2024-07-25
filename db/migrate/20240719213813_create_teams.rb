class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :full_name
      t.string :common_name
      t.string :place_name
      t.string :abbreviation
      t.string :slug
      t.integer :league_id
      t.integer :franchise_id

      t.timestamps
    end
  end
end
