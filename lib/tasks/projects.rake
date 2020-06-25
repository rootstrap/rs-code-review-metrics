##
# The namespace used by the tasks that handles Projects
#
# Call the task from the command line with
#
#       rake projects:update_privacy
namespace :projects do
  desc 'Updates the private column for all projects'
  task update_privacy: :environment do
    Processors::ProjectPrivacyBackfiller.call
  end
end
