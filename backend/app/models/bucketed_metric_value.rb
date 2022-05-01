class BucketedMetricValue < ApplicationRecord
  belongs_to :metric

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
  end
end
