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
  ENABLED_PREFIX = 'enabled'.freeze

  validates :key, uniqueness: true, presence: true

  scope :success_rate, lambda { |entity_name, metric_name|
    where(key: "#{SUCCESS_PREFIX}_#{entity_name}_#{metric_name}")
  }

  scope :enabled, lambda { |feature_name|
    where(key: "#{ENABLED_PREFIX}_#{feature_name}")
  }

  RANSACK_ATTRIBUTES = %w[
    description id id_value key value
  ].freeze
end
