namespace :code_climate do
  desc 'Updates CodeClimateRepositoryMetric cc_repository_id for each repository'
  task link: :environment do
    Processors::CodeClimateUpdater.call
  end
end
