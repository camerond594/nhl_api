class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :time_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
