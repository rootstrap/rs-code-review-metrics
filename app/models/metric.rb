# == Schema Information
#
# Table name: metrics
#
#  id              :bigint           not null, primary key
#  entity_key      :string           not null
#  metric_key      :string           not null
#  value           :decimal(, )
#  value_timestamp :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Metric < ApplicationRecord
  validates :entity_key, presence: true, length: { maximum: 255 }
  validates :metric_key, presence: true, length: { maximum: 255 }
end
