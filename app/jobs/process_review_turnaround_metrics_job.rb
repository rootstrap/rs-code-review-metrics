class ProcessReviewTurnaroundMetricsJob < ApplicationJob
  queue_as :default

  def perform
    Processors::ReviewTurnaround.call
  end
end
