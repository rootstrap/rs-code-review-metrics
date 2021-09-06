module CodeClimate
  class Link < BaseService
    CODE_CLIMATE_API_ORG_NAME = ENV['CODE_CLIMATE_API_ORG_NAME']

    def initialize(repository)
      @repository = repository
    end

    def call
      return if code_climate_project_metric.blank? || !ids_differ?

      code_climate_project_metric.update!(cc_repository_id: external_cc_repository_id)

      Rails.logger.info { message }
    end

    private

    attr_reader :repository

    def code_climate_project_metric
      @code_climate_project_metric ||=
        CodeClimateProjectMetric.find_by(repository_id: repository.id)
    end

    def ids_differ?
      local_cc_repository_id != external_cc_repository_id
    end

    def local_cc_repository_id
      @local_cc_repository_id ||= code_climate_project_metric.cc_repository_id
    end

    def external_cc_repository_id
      @external_cc_repository_id ||= respository_by_slug&.json&.dig('id')
    end

    def respository_by_slug
      CodeClimate::Api::Client.new.repository_by_slug(github_slug: github_slug)
    end

    def github_slug
      "#{CODE_CLIMATE_API_ORG_NAME}/#{repository.name}"
    end

    def message
      <<-MESSAGE
      PROJECT #{code_climate_project_metric.repository_id}
       updated CodeClimateProjectMetric (#{code_climate_project_metric.id})
       cc_repository_id from #{local_cc_repository_id}
       to #{code_climate_project_metric.cc_repository_id}
      MESSAGE
    end
  end
end
