class WeeklyMetricsJob < ApplicationJob
  queue_as :weekly_metrics

  def perform
    Metrics::Weekly::AllMetrics.call
  end
end
