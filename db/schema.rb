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

ActiveRecord::Schema[7.1].define(version: 2024_08_19_042907) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "time_period_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_period_id"], name: "index_events_on_time_period_id"
  end

  create_table "player_stats", force: :cascade do |t|
    t.bigint "roster_assignment_id", null: false
    t.bigint "season_id", null: false
    t.integer "points"
    t.integer "assists"
    t.integer "faceoff_win_pct"
    t.integer "game_winning_goals"
    t.integer "games_played"
    t.integer "goals"
    t.integer "ot_goals"
    t.integer "pim"
    t.integer "plus_minus"
    t.integer "powerplay_goals"
    t.integer "powerplay_points"
    t.integer "shooting_pct"
    t.integer "shorthanded_goals"
    t.integer "shorthanded_points"
    t.integer "shots"
    t.string "avg_toi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roster_assignment_id"], name: "index_player_stats_on_roster_assignment_id"
    t.index ["season_id"], name: "index_player_stats_on_season_id"
  end

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
    t.string "slug"
  end

  create_table "roster_assignments", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "roster_id", null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_roster_assignments_on_player_id"
    t.index ["roster_id"], name: "index_roster_assignments_on_roster_id"
  end

  create_table "rosters", force: :cascade do |t|
    t.string "year"
    t.bigint "team_id", null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_rosters_on_team_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "time_period_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_period_id"], name: "index_seasons_on_time_period_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "full_name"
    t.string "common_name"
    t.string "place_name"
    t.string "abbreviation"
    t.string "slug"
    t.integer "league_id"
    t.integer "franchise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_periods", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_date", "name"], name: "index_time_periods_on_start_date_and_name", unique: true
    t.index ["year"], name: "index_time_periods_on_year"
  end

  add_foreign_key "events", "time_periods"
  add_foreign_key "player_stats", "roster_assignments"
  add_foreign_key "player_stats", "seasons"
  add_foreign_key "roster_assignments", "players"
  add_foreign_key "roster_assignments", "rosters"
  add_foreign_key "rosters", "teams"
  add_foreign_key "seasons", "time_periods"
end
