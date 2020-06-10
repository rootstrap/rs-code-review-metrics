class BlogMetricsFullUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::BlogMetricsFullUpdater.call
  end
end
