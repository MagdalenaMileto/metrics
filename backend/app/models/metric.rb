class Metric < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
