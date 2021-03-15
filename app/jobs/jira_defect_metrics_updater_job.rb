class JiraDefectMetricsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::JiraDefectMetricsUpdater.call
  end
end
