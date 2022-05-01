class CreateBucketedMetricValues < ActiveRecord::Migration[7.0]
  def change
    create_view :bucketed_metric_values, materialized: true
  end
end
