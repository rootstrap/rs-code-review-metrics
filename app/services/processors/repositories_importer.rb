module Processors
  class RepositoriesImporter < Processors::Base
    private

    def process
      repositories.each do |repository_payload|
        Builders::Repository.call(repository_payload)
      end
    end

    def repositories
      GithubClient::Organization.new.repositories
    end
  end
end
