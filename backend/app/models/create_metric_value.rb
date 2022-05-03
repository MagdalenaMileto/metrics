class CreateMetricValue
  def self.register(name, value, timestamp)
    metric = Metric.find_or_create_by!(name: name)

    ActiveRecord::Base.transaction do
      metric_value = MetricValue.create!(timestamp: timestamp, value: value, metric: metric)

      minute_time_bucket = metric_value.timestamp.change(sec: 0)
      minute_aggregate = BucketedMetricAverage.find_or_create_by!(time_bucket: minute_time_bucket, metric: metric, resolution: :minute) do |bucketed_value|
        bucketed_value.value_sum = 0
        bucketed_value.value_count = 0
      end

      minute_aggregate.add(metric_value)
      minute_aggregate.save!

      hour_time_bucket = metric_value.timestamp.change(min: 0)
      hour_aggregate = BucketedMetricAverage.find_or_create_by!(time_bucket: hour_time_bucket, metric: metric, resolution: :hour) do |bucketed_value|
        bucketed_value.value_sum = 0
        bucketed_value.value_count = 0
      end

      hour_aggregate.add(metric_value)
      hour_aggregate.save!

      day_time_bucket = metric_value.timestamp.change(hour: 0)
      day_aggregate = BucketedMetricAverage.find_or_create_by!(time_bucket: day_time_bucket, metric: metric, resolution: :day) do |bucketed_value|
        bucketed_value.value_sum = 0
        bucketed_value.value_count = 0
      end

      day_aggregate.add(metric_value)
      day_aggregate.save!
    end
  end
end
