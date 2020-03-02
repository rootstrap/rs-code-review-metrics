# == Schema Information
#
# Table name: metrics_definitions
#
#  id                        :bigint           not null, primary key
#  last_processed_event_time :datetime
#  metrics_name              :string           not null
#  metrics_processor         :string           not null
#  subject                   :string           not null
#  time_interval             :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class MetricsDefinition < ApplicationRecord
  enum time_intervals: { all_times: 'all_times', daily: 'daily', weekly: 'weekly' }
  enum subjects: { projects: 'projects', users: 'users', users_per_project: 'users_per_project' }
  DURATIONS = { 'all_times' => nil, 'daily' => 1.day, 'weekly' => 7.days }.freeze

  validates :metrics_name, presence: true, length: { maximum: 255 }
  validates :time_interval, presence: true, inclusion: { in: time_intervals.keys }
  validates :subject, presence: true, inclusion: { in: subjects.keys }
  validates :metrics_processor, presence: true

  def time_interval_starting_at(start_time)
    TimeInterval.new(starting_at: start_time, duration: DURATIONS[time_interval])
  end
end
