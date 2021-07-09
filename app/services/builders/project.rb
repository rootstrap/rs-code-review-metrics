module Builders
  class Project < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      fetch_or_create
    end

    private

    def fetch_or_create
      ::Project.with_deleted
               .find_or_initialize_by(github_id: @repository_data['id'])
               .tap do |project|
        project.recover if project.deleted?
        project.name = @repository_data['name']
        project.description = @repository_data['description']
        project.is_private = @repository_data['private']
        project.relevance = ::Project.relevances[:ignored] if @repository_data['archived']
        project.save!
      end
    end
  end
end
