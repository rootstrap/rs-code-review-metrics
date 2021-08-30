##
# The namespace used by the tasks that handles the Jira data metrics.
#
# Call the task from the command line with
#
#       rake jira:update_jira_data
namespace :jira do
  desc 'Updates jira data for metrics'
  task update_jira_data: :environment do
    JiraDefectMetricsUpdaterJob.perform_now
  end
end
