class OpenSourceMetricsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::OpenSourceMetricsUpdater.call
  end
end
