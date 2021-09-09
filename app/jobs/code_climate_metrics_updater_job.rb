class CodeClimateMetricsUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::CodeClimateUpdateAllRepositoriesService.call
  end
end
