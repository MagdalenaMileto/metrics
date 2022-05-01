json.name @metric_name
json.resolution @resolution
json.metricValues @bucketed_metric_values do |bucketed_value|
  json.timeBucket bucketed_value.time_bucket.iso8601
  json.average bucketed_value.avg
end

