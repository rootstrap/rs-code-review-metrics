# == Schema Information
#
# Table name: metrics
#
#  id              :bigint           not null, primary key
#  ownable_type    :string           not null
#  value           :decimal(, )
#  value_timestamp :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ownable_id      :bigint           not null
#
# Indexes
#
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#

class Metric < ApplicationRecord
  belongs_to :ownable, polymorphic: true
end
