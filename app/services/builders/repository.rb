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
      repository = find_or_initialize_repository
      update_repository_attributes(repository)
      repository.save!
      repository
    end

    def find_or_initialize_repository
      ::Repository.with_deleted
                  .find_or_initialize_by(github_id: @repository_data['id']).tap do |repository|
        repository.recover if repository.deleted?
      end
    end

    def update_repository_attributes(repository)
      repository.name = @repository_data['name']
      repository.description = @repository_data['description']
      repository.is_private = @repository_data['private']
      repository.relevance = ::Repository.relevances[:ignored] if @repository_data['archived']
    end
  end
end
