module Builders
  class ExternalProject < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      ::ExternalProject.find_or_create_by!(github_id: @repository_data[:id]) do |project|
        name = @repository_data[:name]

        project.name = name.split('/').second
        project.full_name = name
      end
    end
  end
end
