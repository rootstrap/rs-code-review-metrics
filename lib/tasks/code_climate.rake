namespace :code_climate do
  desc 'Updates the CodeClimate information for all projects'
  task update: :environment do
    CodeClimate::UpdateAllProjectsService.call
  end
end
