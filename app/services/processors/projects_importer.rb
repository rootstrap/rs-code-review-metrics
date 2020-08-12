module Processors
  class ProjectsImporter < Processors::Base
    private

    def process
      repositories.each do |repository_payload|
        Builders::Project.call(repository_payload)
      end
    end

    def repositories
      GithubClient::Organization.new.repositories
    end
  end
end
