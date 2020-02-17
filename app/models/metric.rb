class Metric < ApplicationRecord
  validates :entity_key, presence: true, length: { maximum: 255 }
  validates :metric_key, presence: true, length: { maximum: 255 }
end
