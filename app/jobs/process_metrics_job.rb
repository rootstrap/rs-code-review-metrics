##
# This job processes the Github events previously stored, generates the
# metrics and leaves them in a ready to use state.
#
# Implementation note: this PR just creates the job placeholder. The job is
# be implemented in a different PR.
class ProcessMetricsJob < ApplicationJob
  queue_as :default

  ##
  # Does the processing of the Github events previously stored and leaves them
  # generated metrics in the metrics table.
  #
  # It takes care of processing only the metrics that are pending to be
  # processed.
  def perform
    # todo
  end
end
