# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  entity_key            :string           not null
#  metric_key            :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#
# Indexes
#
#  index_metrics_on_metrics_definition_id  (metrics_definition_id)
#
# Foreign Keys
#
#  fk_rails_...  (metrics_definition_id => metrics_definitions.id)
#

class Metric < ApplicationRecord
  belongs_to :metrics_definition, inverse_of: :metrics

  validates :entity_key, presence: true, length: { maximum: 255 }
  validates :metric_key, presence: true, length: { maximum: 255 }
end
