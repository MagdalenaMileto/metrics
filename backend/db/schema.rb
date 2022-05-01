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

ActiveRecord::Schema[7.0].define(version: 2022_05_01_180052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "metric_values", "metrics"

  create_view "bucketed_metric_values", materialized: true, sql_definition: <<-SQL
      SELECT date_trunc('minute'::text, metric_values."timestamp") AS time_bucket,
      metric_values.metric_id,
      sum(metric_values.value) AS value_sum,
      count(*) AS value_count,
      'minute'::text AS resolution
     FROM metric_values
    GROUP BY (date_trunc('minute'::text, metric_values."timestamp")), metric_values.metric_id
  UNION
   SELECT date_trunc('hour'::text, metric_values."timestamp") AS time_bucket,
      metric_values.metric_id,
      sum(metric_values.value) AS value_sum,
      count(*) AS value_count,
      'hour'::text AS resolution
     FROM metric_values
    GROUP BY (date_trunc('hour'::text, metric_values."timestamp")), metric_values.metric_id
  UNION
   SELECT date_trunc('day'::text, metric_values."timestamp") AS time_bucket,
      metric_values.metric_id,
      sum(metric_values.value) AS value_sum,
      count(*) AS value_count,
      'day'::text AS resolution
     FROM metric_values
    GROUP BY (date_trunc('day'::text, metric_values."timestamp")), metric_values.metric_id;
  SQL
  add_index "bucketed_metric_values", ["metric_id", "resolution", "time_bucket"], name: "bucketed_metric_values_idx_unique", unique: true

end
