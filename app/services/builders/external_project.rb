module Builders
  class ExternalProject < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      ::ExternalProject.find_or_create_by!(github_id: @repository_data[:id]) do |project|
        project.name = @repository_data[:name]
        project.full_name = @repository_data[:full_name]
        project.description = @repository_data[:description]
      end
    end
  end
end
