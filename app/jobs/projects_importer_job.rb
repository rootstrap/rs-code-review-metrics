class ProjectsImporterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::ProjectsImporter.call
  end
end
