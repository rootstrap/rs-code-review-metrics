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
  TIME_INTERVALS = { daily: TimeIntervals::DailyInterval }.freeze

  validates :metrics_name, presence: true, length: { maximum: 255 }
  validates :time_interval, presence: true, inclusion: { in: time_intervals.keys }
  validates :subject, presence: true, inclusion: { in: subjects.keys }
  validates :metrics_processor, presence: true

  ##
  # Returns the TimeInterval object, for example TimeIntervals::DailyInterval,
  # for this MetricsDefinition
  def time_period
    @time_period ||= time_interval_to_time_period
  end

  private

  ##
  # Converts the receiver time_interval string to a TimeInterval object
  def time_interval_to_time_period
    time_interval ? TIME_INTERVALS.fetch(time_interval.to_sym) : nil
  end
end
