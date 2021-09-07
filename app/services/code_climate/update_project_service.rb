module CodeClimate
  class UpdateProjectService < BaseService
    def initialize(repository)
      @repository = repository
    end

    def call
      return unless update_metric? && code_climate_project_summary.present?

      update_metric
    rescue Faraday::Error => exception
      response = exception.response
      error = response[:status].to_s + ' - ' + response[:body]
      SlackService.code_climate_error(repository, error)
    end

    private

    attr_reader :repository

    def update_metric
      project_code_climate_metric.update!(
        code_climate_rate: code_climate_project_summary.rate,
        invalid_issues_count: code_climate_project_summary.invalid_issues_count,
        open_issues_count: code_climate_project_summary.open_issues_count,
        wont_fix_issues_count: code_climate_project_summary.wont_fix_issues_count,
        snapshot_time: code_climate_project_summary.snapshot_time,
        cc_repository_id: code_climate_project_summary.repo_id,
        test_coverage: code_climate_project_summary.test_coverage
      )
    end

    def code_climate_project_summary
      @code_climate_project_summary ||= CodeClimate::GetProjectSummary.call(repository: repository)
    end

    def today
      Time.zone.today.beginning_of_day
    end

    def update_metric?
      metric_last_updated_at = project_code_climate_metric.updated_at
      metric_last_updated_at.blank? || metric_last_updated_at < today
    end

    def project_code_climate_metric
      @project_code_climate_metric ||=
        CodeClimateProjectMetric.find_or_initialize_by(repository: repository)
    end
  end
end
