module CodeClimate
  class GetProjectSummary < BaseService
    def initialize(github_slug:)
      @github_slug = github_slug
    end

    def call
      repository&.summary
    end

    def repository
      CodeClimate::Api::Client.new.repository_by_slug(github_slug: @github_slug)
    end
  end
end
