##
# The namespace used by the tasks that handles the Github event metrics.
#
# Call the task from the command line with
#
#       rake metrics:process
namespace :metrics do
  desc 'Processes the stored events and generates the all the metrics'
  task process: :environment do
    ProcessMetricsJob.new.perform
  end
end
