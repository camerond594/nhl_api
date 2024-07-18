class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.integer :player_id
      t.boolean :active
      t.integer :current_team_id
      t.string :first_name
      t.string :last_name
      t.integer :sweater_number
      t.string :position
      t.string :headshot_url
      t.string :hero_image_url
      t.integer :height_in_inches
      t.integer :height_in_centimeters
      t.integer :weight_in_pounds
      t.integer :weight_in_kilograms
      t.string :birth_date
      t.string :birth_city
      t.string :birth_state_province
      t.string :birth_country
      t.string :shoots_catches

      t.timestamps
    end
  end
end
