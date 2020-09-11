##
# The namespace used by the tasks that handles the Github event metrics.
#
# Call the task from the command line with
#
#       rake metrics:process
namespace :metrics do
  desc 'Processes the stored events and generates the all the metrics'
  task process: :environment do
    ProcessReviewTurnaroundMetricsJob.perform_now
  end

  desc 'Updates all PR Size metrics'
  task update_pr_size: :environment do
    PullRequestSizeUpdaterJob.perform_now
  end
end
