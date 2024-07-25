class CreateRosters < ActiveRecord::Migration[7.1]
  def change
    create_table :rosters do |t|
      t.string :year
      t.references :team, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
