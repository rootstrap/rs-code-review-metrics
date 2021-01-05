namespace :code_climate do
  desc 'Updates CodeClimateProjectMetric cc_repository_id for each project'
  task link: :environment do
    Processors::CodeClimateUpdater.call
  end
end
