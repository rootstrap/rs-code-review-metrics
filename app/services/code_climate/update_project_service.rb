module CodeClimate
  class UpdateProjectService < BaseService
    CODE_CLIMATE_API_ORG_NAME = 'rootstrap'.freeze

    def initialize(project)
      @project = project
    end

    def call
      return unless update_metric? && code_climate_project_summary.present?

      update_metric
    rescue Faraday::Error => exception
      ExceptionHunter.track(exception)
    end

    private

    def update_metric
      create_project_code_climate_metric unless project_code_climate_metric

      project_code_climate_metric.update!(
        code_climate_rate: code_climate_project_summary.rate,
        invalid_issues_count: code_climate_project_summary.invalid_issues_count,
        open_issues_count: code_climate_project_summary.open_issues_count,
        wont_fix_issues_count: code_climate_project_summary.wont_fix_issues_count,
        snapshot_time: code_climate_project_summary.snapshot_time
      )
    end

    def code_climate_project_summary
      @code_climate_project_summary ||=
        CodeClimate::GetProjectSummary.call(github_slug: project_name)
    end

    def today
      Time.zone.today.beginning_of_day
    end

    def update_metric?
      !project_code_climate_metric || project_code_climate_metric.updated_at < today
    end

    def project_code_climate_metric
      @project_code_climate_metric ||= CodeClimateProjectMetric.find_by(project: @project)
    end

    def create_project_code_climate_metric
      @project_code_climate_metric = CodeClimateProjectMetric.create!(
        project: @project,
        snapshot_time: code_climate_project_summary.snapshot_time
      )
    end

    def project_name
      "#{CODE_CLIMATE_API_ORG_NAME}/#{@project.name}"
    end
  end
end
