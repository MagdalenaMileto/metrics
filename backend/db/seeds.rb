metrics = %w[wind pressure temperature humidity chocolates_eaten naps_taken net_income sales time_to_hire turnover kebabs_eaten]

metrics.each { |metric_name| Metric.create!(name: metric_name) }