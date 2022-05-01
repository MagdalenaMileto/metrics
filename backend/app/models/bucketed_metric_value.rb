class BucketedMetricValue < ApplicationRecord
  belongs_to :metric

  def self.average(name, resolution)
    metric = Metric.find_by!(name: name)

    BucketedMetricValue.where(metric_id: metric.id, resolution: resolution)
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
  end

  def avg
    value_sum.to_f / value_count
  end
end
