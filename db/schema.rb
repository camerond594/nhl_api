# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_17_202305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.integer "player_id"
    t.boolean "active"
    t.integer "current_team_id"
    t.string "first_name"
    t.string "last_name"
    t.integer "sweater_number"
    t.string "position"
    t.string "headshot_url"
    t.string "hero_image_url"
    t.integer "height_in_inches"
    t.integer "height_in_centimeters"
    t.integer "weight_in_pounds"
    t.integer "weight_in_kilograms"
    t.string "birth_date"
    t.string "birth_city"
    t.string "birth_state_province"
    t.string "birth_country"
    t.string "shoots_catches"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
