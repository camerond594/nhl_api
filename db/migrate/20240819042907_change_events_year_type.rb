class ChangeEventsYearType < ActiveRecord::Migration[7.1]
  def change
    change_column :time_periods, :year, :string
  end
end
