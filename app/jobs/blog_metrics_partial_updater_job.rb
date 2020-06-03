class BlogMetricsPartialUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogMetricsPartialUpdater.call
  end
end
