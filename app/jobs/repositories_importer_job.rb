class RepositoriesImporterJob < ApplicationJob
  queue_as :default

  def perform
    Processors::RepositoriesImporter.call
  end
end
