##
# The namespace used by the tasks that handles the Technologies for the blog metrics
#
# Call the task from the command line with
#
#       rake technologies:backfill
namespace :technologies do
  desc 'Backfills the DB with all the technologies needed'
  task backfill: :environment do
    Processors::TechnologiesBackfiller.call
  end
end
