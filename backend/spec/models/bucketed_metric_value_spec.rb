require 'rails_helper'

describe BucketedMetricValue, type: :model do
  let(:metric) { Metric.create!(name: 'temperature') }

  it 'groups metrics by day' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 0, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)

    day2_t1 = Time.zone.local(2022, 5, 1, 12, 0, 0)
    MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)

    BucketedMetricValue.refresh

    by_day = BucketedMetricValue.where(resolution: 'day')
    expect(by_day.length).to eq(2)

    expect(BucketedMetricValue.find_by(resolution: 'day', time_bucket: Time.zone.local(2022, 4, 30, 0, 0, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricValue.find_by(resolution: 'day', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'groups by hour' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 0, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)

    day2_t1 = Time.zone.local(2022, 4, 30, 13, 0, 0)
    MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)

    day3_t1 = Time.zone.local(2022, 5, 1, 8, 0, 0)
    MetricValue.create!(metric: metric, value: 3, timestamp: day3_t1)

    BucketedMetricValue.refresh

    by_day = BucketedMetricValue.where(resolution: 'hour')
    expect(by_day.length).to eq(3)

    expect(BucketedMetricValue.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 4, 30, 12, 0, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricValue.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 4, 30, 13, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricValue.find_by(resolution: 'hour', time_bucket: Time.zone.local(2022, 5, 1, 8, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'groups by minute' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 45, 0)
    day1_t2 = Time.zone.local(2022, 4, 30, 12, 45, 33)
    MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)
    MetricValue.create!(metric: metric, value: 5, timestamp: day1_t2)

    day2_t1 = Time.zone.local(2022, 4, 30, 12, 55, 0)
    MetricValue.create!(metric: metric, value: 3, timestamp: day2_t1)

    day3_t1 = Time.zone.local(2022, 5, 1, 0, 0, 0)
    MetricValue.create!(metric: metric, value: 3, timestamp: day3_t1)

    BucketedMetricValue.refresh

    by_day = BucketedMetricValue.where(resolution: 'minute')
    expect(by_day.length).to eq(3)

    expect(BucketedMetricValue.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 4, 30, 12, 45, 0))).to have_attributes(value_count: 2, value_sum: 15)

    expect(BucketedMetricValue.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 4, 30, 12, 55, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricValue.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)

    expect(BucketedMetricValue.find_by(resolution: 'minute', time_bucket: Time.zone.local(2022, 5, 1, 0, 0, 0))).to have_attributes(value_count: 1, value_sum: 3)
  end

  it 'aggregates by metric' do
    day1_t1 = Time.zone.local(2022, 4, 30, 12, 45, 0)
    MetricValue.create!(metric: metric, value: 10, timestamp: day1_t1)

    different_metric = Metric.create(name: 'wind')
    MetricValue.create!(metric: different_metric, value: 3, timestamp: day1_t1)

    BucketedMetricValue.refresh

    expect(BucketedMetricValue.count).to eq(6)

    expected_resolutions = ['day', 'hour', 'minute']

    expect(BucketedMetricValue.where(metric: metric).pluck(:resolution).sort).to eq(expected_resolutions)

    expect(BucketedMetricValue.where(metric: different_metric).pluck(:resolution).sort).to eq(expected_resolutions)
  end
end
