module CodeClimate
  class GetProjectSummary < BaseService
    CODE_CLIMATE_API_ORG_NAME = 'rootstrap'.freeze

    def initialize(project:)
      @project = project
    end

    def call
      repository&.summary
    end

    private

    attr_reader :project

    def repository
      repo_id = project.code_climate_project_metric&.cc_repository_id

      if repo_id.present?
        CodeClimate::Api::Client.new.repository_by_repo_id(repo_id: repo_id)
      else
        CodeClimate::Api::Client.new.repository_by_slug(github_slug: github_slug)
      end
    end

    def github_slug
      "#{CODE_CLIMATE_API_ORG_NAME}/#{project.name}"
    end
  end
end
