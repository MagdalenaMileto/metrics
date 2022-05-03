class BucketedMetricAverage < ApplicationRecord
  enum resolution: { minute: 'minute', hour: 'hour', day: 'day' }

  belongs_to :metric

  validates :time_bucket, presence: true
  validates :value_sum, presence: true
  validates :value_count, presence: true
  validates :resolution, inclusion: {in: resolutions.keys}

  def self.average(name, resolution)
    metric = Metric.find_by!(name: name)
    BucketedMetricAverage.where(metric: metric, resolution: resolution)
  end

  def add(metric_value)
    update!(value_sum: value_sum + metric_value.value, value_count: value_count + 1)
  end

  def avg
    value_sum.to_f / value_count
  end
end
