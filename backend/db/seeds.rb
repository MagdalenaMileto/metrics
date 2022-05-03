metrics = %w[cost_per_hire time_to_hire time_since_last_promotion revenue_per_employee_2020 revenue_per_employee_2021 revenue_per_employee_2022 engagement turnover absenteeism]

metrics.each { |metric_name| Metric.create!(name: metric_name) }

cost_per_hire_values = [
  [300, Time.zone.local(2022, 4, 29, 16, 00, 00)],
  [300, Time.zone.local(2022, 4, 29, 16, 10, 00)],
  [300, Time.zone.local(2022, 4, 29, 16, 40, 00)],
  [300, Time.zone.local(2022, 4, 29, 17, 00, 00)],
  [100, Time.zone.local(2022, 4, 30, 12, 10, 00)],
  [500, Time.zone.local(2022, 4, 30, 12, 20, 00)],
  [300, Time.zone.local(2022, 4, 30, 13, 10, 00)],
  [400, Time.zone.local(2022, 4, 30, 13, 20, 00)],
  [50, Time.zone.local(2022, 4, 30, 14, 30, 00)],
  [325, Time.zone.local(2022, 4, 30, 14, 40, 00)],
  [152, Time.zone.local(2022, 5, 1, 12, 10, 00)],
  [550, Time.zone.local(2022, 5, 1, 12, 20, 00)],
  [370, Time.zone.local(2022, 5, 1, 13, 10, 00)],
  [408, Time.zone.local(2022, 5, 1, 14, 10, 00)],
  [590, Time.zone.local(2022, 5, 1, 14, 20, 00)],
  [600, Time.zone.local(2022, 5, 2, 12, 10, 00)],
  [450, Time.zone.local(2022, 5, 2, 12, 20, 00)],
  [370, Time.zone.local(2022, 5, 2, 12, 30, 00)],
  [400, Time.zone.local(2022, 5, 2, 12, 40, 00)],
  [590, Time.zone.local(2022, 5, 2, 12, 50, 00)],
]

cost_per_hire = Metric.find_by(name: 'cost_per_hire')
cost_per_hire_values.each { |value, timestamp| CreateMetricValue.register(cost_per_hire.name, value, timestamp) }