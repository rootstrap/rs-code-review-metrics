# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  ownable_type          :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#  ownable_id            :bigint           not null
#
# Indexes
#
#  index_metrics_on_metrics_definition_id        (metrics_definition_id)
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#
# Foreign Keys
#
#  fk_rails_...  (metrics_definition_id => metrics_definitions.id)
#

class Metric < ApplicationRecord
  belongs_to :metrics_definition, inverse_of: :metrics
  belongs_to :ownable, polymorphic: true
end
