class CreateTimePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :time_periods do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.integer :year

      t.timestamps
    end

    add_index :time_periods, :year
    add_index :time_periods, [:start_date, :name], unique: true
  end
end
