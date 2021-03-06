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

ActiveRecord::Schema[7.0].define(version: 2022_05_03_144802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bucketed_metric_averages", force: :cascade do |t|
    t.bigint "metric_id"
    t.datetime "time_bucket", precision: nil
    t.integer "value_sum"
    t.integer "value_count"
    t.string "resolution"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_id", "resolution", "time_bucket"], name: "bucketed_metric_avg_idx_unique", unique: true
    t.index ["metric_id"], name: "index_bucketed_metric_averages_on_metric_id"
  end

  create_table "metric_values", force: :cascade do |t|
    t.bigint "metric_id"
    t.datetime "timestamp", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value"
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_metrics_on_name", unique: true
  end

  add_foreign_key "bucketed_metric_averages", "metrics"
  add_foreign_key "metric_values", "metrics"
end
