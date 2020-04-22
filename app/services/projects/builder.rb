module Projects
  class Builder < BaseService
    def initialize(repository_data)
      @repository_data = repository_data
    end

    def call
      fetch_or_create
    end

    private

    def fetch_or_create
      Project.find_or_create_by!(github_id: @repository_data['id']) do |project|
        project.name = @repository_data['name']
        project.description = @repository_data['description']
      end
    end
  end
end
