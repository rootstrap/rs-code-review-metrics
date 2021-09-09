module Builders
  class Repository < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      fetch_or_create
    end

    private

    def fetch_or_create
      ::Repository.with_deleted
                  .find_or_initialize_by(github_id: @repository_data['id'])
                  .tap do |repository|
        repository.recover if repository.deleted?
        repository.name = @repository_data['name']
        repository.description = @repository_data['description']
        repository.is_private = @repository_data['private']
        repository.relevance = ::Repository.relevances[:ignored] if @repository_data['archived']
        repository.save!
      end
    end
  end
end
