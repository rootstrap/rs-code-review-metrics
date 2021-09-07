##
# The namespace used by the tasks that handles Repositories
#
# Call the task from the command line with
#
#       rake repositories:update_privacy
namespace :repositories do
  desc 'Updates the is_private column for all repositories'
  task update_privacy: :environment do
    Processors::RepositoryPrivacyBackfiller.call
  end
end
