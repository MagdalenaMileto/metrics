require 'rails_helper'

describe BucketedMetricAverage, type: :model do
  let(:metric) { Metric.create!(name: 'temperature') }

  it 'groups metrics by day' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 0, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    metric_value_1_day1 = MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    metric_value_2_day1 = MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)
    CreateMetricValue.register(metric.name, metric_value_1_day1.value, metric_value_1_day1.timestamp)
    CreateMetricValue.register(metric.name, metric_value_2_day1.value, metric_value_2_day1.timestamp)

    day2_t1 = Time.zone.local(2022, 5, 1, 12, 10, 0)
    metric_value_2_day2 = MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)
    CreateMetricValue.register(metric.name, metric_value_2_day2.value, metric_value_2_day2.timestamp)

    by_day = BucketedMetricAverage.where(resolution: 'day')
    expect(by_day.length).to eq(2)

    expect(BucketedMetricAverage.find_by(resolution: 'day', time_bucket: Time.zone.local(2022, 4, 30, 0, 0, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricAverage.find_by(resolution: 'day', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'groups by hour' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 0, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    metric_value_1_day1 = MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    metric_value_2_day1 = MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)
    CreateMetricValue.register(metric.name, metric_value_1_day1.value, metric_value_1_day1.timestamp)
    CreateMetricValue.register(metric.name, metric_value_2_day1.value, metric_value_2_day1.timestamp)

    day2_t1 = Time.zone.local(2022, 4, 30, 13, 0, 0)
    metric_value_1_day2 = MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)
    CreateMetricValue.register(metric.name, metric_value_1_day2.value, metric_value_1_day2.timestamp)

    day3_t1 = Time.zone.local(2022, 5, 1, 8, 0, 0)
    metric_value_1_day3 = MetricValue.create!(metric: metric, value: 3, timestamp: day3_t1)
    CreateMetricValue.register(metric.name, metric_value_1_day3.value, metric_value_1_day3.timestamp)

    by_day = BucketedMetricAverage.where(resolution: 'hour')
    expect(by_day.length).to eq(3)

    expect(BucketedMetricAverage.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 4, 30, 12, 0, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricAverage.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 4, 30, 13, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricAverage.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 5, 1, 8, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'groups by minute' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 45, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    metric_value_1_day1 = MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    metric_value_2_day1 = MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)
    CreateMetricValue.register(metric.name, metric_value_1_day1.value, metric_value_1_day1.timestamp)
    CreateMetricValue.register(metric.name, metric_value_2_day1.value, metric_value_2_day1.timestamp)

    day2_t1 = Time.zone.local(2022, 4, 30, 12, 55, 0)
    metric_value_1_day2 = MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)
    CreateMetricValue.register(metric.name, metric_value_1_day2.value, metric_value_1_day2.timestamp)

    day3_t1 = Time.zone.local(2022, 5, 1, 0, 0, 0)
    metric_value_1_day3 = MetricValue.create!(metric: metric, value: 3, timestamp: day3_t1)
    CreateMetricValue.register(metric.name, metric_value_1_day3.value, metric_value_1_day3.timestamp)

    by_day = BucketedMetricAverage.where(resolution: 'minute')
    expect(by_day.length).to eq(3)

    expect(BucketedMetricAverage.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 4, 30, 12, 45, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricAverage.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 4, 30, 12, 55, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricAverage.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricAverage.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'aggregates by metric' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 45, 0)
    metric_value_1_day1 =  MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    CreateMetricValue.register(metric.name, metric_value_1_day1.value, metric_value_1_day1.timestamp)

    different_metric = Metric.create(name: 'wind')
    metric_value_2_day1 = MetricValue.create!(metric: different_metric, value: 3, timestamp: day1_t1)
    CreateMetricValue.register(different_metric.name, metric_value_2_day1.value, metric_value_2_day1.timestamp)

    expect(BucketedMetricAverage.count).to eq(6)

    expected_resolutions = ['day', 'hour', 'minute']

    expect(BucketedMetricAverage.where(metric: metric).pluck(:resolution).sort).to eq(expected_resolutions)

    expect(BucketedMetricAverage.where(metric: different_metric).pluck(:resolution).sort).to eq(expected_resolutions)
  end
end
