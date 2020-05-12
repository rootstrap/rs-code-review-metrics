class ProcessMergeTimeMetricsJob < ApplicationJob
  queue_as :default

  def perform
    Processors::MergeTime.call
  end
end
