class CreateRosterAssignment < ActiveRecord::Migration[7.1]
  def change
    create_table :roster_assignments do |t|
      t.references :player, null: false, foreign_key: true
      t.references :roster, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
