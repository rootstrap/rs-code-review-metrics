module CodeClimate
  class UpdateProjectService < BaseService
    CODE_CLIMATE_API_ORG_NAME = 'rootstrap'.freeze

    def initialize(project)
      @project = project
    end

    def call
      return unless update_metric?
      return unless code_climate_project_info

      create_project_code_climate_metric unless project_code_climate_metric

      project_code_climate_metric.update!(
        code_climate_rate: code_climate_project_info[:rate],
        invalid_issues_count: code_climate_project_info[:invalid_issues_count],
        wont_fix_issues_count: code_climate_project_info[:wont_fix_issues_count]
      )
    end

    private

    def code_climate_project_info
      @code_climate_project_info ||= CodeClimate::GetProjectInfo.call(github_slug: project_name)
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
      @project_code_climate_metric = CodeClimateProjectMetric.create!(project: @project)
    end

    def project_name
      "#{CODE_CLIMATE_API_ORG_NAME}/#{@project.name}"
    end
  end
end
