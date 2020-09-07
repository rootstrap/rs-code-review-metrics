class ExternalContributionsProcessorJob < ApplicationJob
  queue_as :default

  def perform
    Processors::External::Contributions.call
  end
end
