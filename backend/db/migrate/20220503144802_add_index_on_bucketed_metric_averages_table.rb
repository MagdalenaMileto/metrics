class AddIndexOnBucketedMetricAveragesTable < ActiveRecord::Migration[7.0]
  def change
    add_index :bucketed_metric_values, [:metric_id, :resolution, :time_bucket], unique: true, name: 'bucketed_metric_avg_idx_unique'
  end
end
