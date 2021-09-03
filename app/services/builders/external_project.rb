module Builders
  class ExternalProject < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      ::ExternalRepository.find_or_create_by!(github_id: @repository_data[:id]) do |repository|
        repository.name = @repository_data[:name]
        repository.full_name = @repository_data[:full_name]
        repository.description = @repository_data[:description]
      end
    end
  end
end
