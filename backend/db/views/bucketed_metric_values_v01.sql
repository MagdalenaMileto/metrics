SELECT DATE_TRUNC('minute', timestamp) as time_bucket,
       SUM(value)                      as value_sum,
       COUNT(*)                        as value_count,
       'minute'                        as resolution
FROM metric_values
GROUP BY DATE_TRUNC('minute', timestamp)

UNION

SELECT DATE_TRUNC('hour', timestamp) as time_bucket,
       SUM(value)                    as value_sum,
       COUNT(*)                      as value_count,
       'hour'                        as resolution
FROM metric_values
GROUP BY DATE_TRUNC('hour', timestamp)

UNION

SELECT DATE_TRUNC('day', timestamp) as time_bucket,
       SUM(value)                   as value_sum,
       COUNT(*)                     as value_count,
       'day'                        as resolution
FROM metric_values
GROUP BY DATE_TRUNC('day', timestamp)