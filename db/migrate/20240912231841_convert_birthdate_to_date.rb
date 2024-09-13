class ConvertBirthdateToDate < ActiveRecord::Migration[7.1]
  def up
    # Add a temporary column for storing the correct dates
    add_column :players, :birth_date_tmp, :date

    # Loop through each player and convert the birthdate string to a date
    Player.reset_column_information
    Player.find_each do |player|
      if player.birth_date.present?
        begin
          # Parse the string to a valid date (adjust the format as necessary)
          parsed_date = Date.parse(player.birth_date)
          player.update_columns(birth_date_tmp: parsed_date)
        rescue ArgumentError
          # Handle invalid dates or log them
          Rails.logger.error("Invalid birthdate for player ID #{player.id}: #{player.birth_date}")
        end
      end
    end

    # Replace the old birthdate column with the new one
    remove_column :players, :birth_date
    rename_column :players, :birth_date_tmp, :birth_date
  end

  def down
    # In case of rollback, change birthdate back to string
    change_column :players, :birth_date, :string
  end
end
