# == Schema Information
#
# Table name: metrics_definitions
#
#  id            :bigint           not null, primary key
#  metrics_name  :string           not null
#  subject       :string           not null
#  time_interval :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class MetricsDefinition < ApplicationRecord
  enum time_intervals: { all_times: 'all_times', daily: 'daily', weekly: 'weekly' }
  enum subjects: { projects: 'projects', users: 'users', users_per_project: 'users_per_project' }

  validates :metrics_name, presence: true, length: { maximum: 255 }
  validates :time_interval, presence: true, inclusion: { in: time_intervals.keys }
  validates :subject, presence: true, inclusion: { in: subjects.keys }

  def metrics_processor
    Metrics::ReviewTurnaroundProcessor
  end
end
