class MetricValue < ApplicationRecord
  belongs_to :metric

  validates :timestamp, presence: true
  validates :value, presence: true
end
