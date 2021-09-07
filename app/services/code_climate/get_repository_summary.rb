module CodeClimate
  class GetRepositorySummary < BaseService
    CODE_CLIMATE_API_ORG_NAME = ENV['CODE_CLIMATE_API_ORG_NAME']

    def initialize(repository:)
      @repository = repository
    end

    def call
      find_repository&.summary
    end

    private

    attr_reader :repository

    def find_repository
      repo_id = repository.code_climate_repository_metric&.cc_repository_id

      if repo_id.present?
        CodeClimate::Api::Client.new.repository_by_repo_id(repo_id: repo_id)
      else
        CodeClimate::Api::Client.new.repository_by_slug(github_slug: github_slug)
      end
    end

    def github_slug
      "#{CODE_CLIMATE_API_ORG_NAME}/#{repository.name}"
    end
  end
end
