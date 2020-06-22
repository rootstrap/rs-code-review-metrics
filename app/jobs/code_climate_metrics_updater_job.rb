class CodeClimateMetricsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::CodeClimateUpdateAllProjectsService.call
  end
end
