# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  description :string           default("")
#  key         :string           not null
#  value       :string
#

class Setting < ApplicationRecord
  SUCCESS_PREFIX = 'success_rate'.freeze

  validates :key, uniqueness: true, presence: true

  scope :admin_docs, -> { where('key LIKE ?', "#{ADMIN_DOCS_PREFIX}%") }
  scope :success_rate, lambda { |department_name, metric_name|
    where(key: "#{SUCCESS_PREFIX}_#{department_name}_#{metric_name}")
  }
end
