module CodeClimate
  class GetProjectInfo < BaseService
    def initialize(repository_id: nil, github_slug: nil)
      @repository_id = repository_id
      @github_slug = github_slug
    end

    def call
      return if repository&.json.blank?

      repository&.summary
    end

    def repository
      @repository ||= CodeClimate::Api::Client.new.repository(
        repository_id: @repository_id,
        github_slug: @github_slug
      )
    end
  end
end
