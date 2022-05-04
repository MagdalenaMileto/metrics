metrics = [
  { name: "temperature", between: [10, 30] },
  { name: "humidity", between: [20, 90] },
  { name: "wind", between: [20, 130] },
  { name: "atmosphere_pressure", between: [1000, 10050] },
  { name: "precipitation", between: [10, 1000] }
]

metrics.each { |metric| Metric.create!(name: metric[:name]) }

date_1 = Time.now
date_2 = date_1 - 5.days

metrics.each do |metric|
  first_value = metric[:between][0].to_i
  second_value = metric[:between][1].to_i

  found_metric = Metric.find_by(name: "#{metric[:name]}")

  puts "seeding #{found_metric.name}"

  100.times do |index|
    value = rand(first_value..second_value)
    timestamp = date_1 + index.minutes
    CreateMetricValue.register(found_metric.name, value, timestamp)
  end

  100.times do |index|
    value = rand(first_value..second_value)
    timestamp = date_2 + index.hour
    CreateMetricValue.register(found_metric.name, value, timestamp)
  end
end