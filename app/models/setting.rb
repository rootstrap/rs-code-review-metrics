# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string           default("")
#  key         :string           not null
#  value       :string
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#

class Setting < ApplicationRecord
  SUCCESS_PREFIX = 'success_rate'.freeze

  validates :key, uniqueness: true, presence: true

  scope :success_rate, lambda { |department_name, metric_name|
    where(key: "#{SUCCESS_PREFIX}_#{department_name}_#{metric_name}")
  }
end
