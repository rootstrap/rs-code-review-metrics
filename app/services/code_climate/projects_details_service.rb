module CodeClimate
  class ProjectsDetailsService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies: [])
      @department = department
      @from = from.to_i
      @technologies = technologies
    end

    def call
      build_summary
    end

    private

    def build_summary
      return ProjectsSummary.new unless metrics?

      code_climate_metrics.map do |metric|
        ProjectSummary.new(metric: metric,
                           project_name: metric.project.name)
      end
    end

    def metrics?
      !code_climate_metrics.empty?
    end

    def code_climate_metrics
      @code_climate_metrics ||= metrics_in_given_technologies
    end

    def metrics_in_given_technologies
      if technologies.present?
        metrics_in_time_period.where(languages: { name: technologies })
      else
        metrics_in_time_period
      end
    end

    def metrics_in_time_period
      if from && !from.zero?
        metrics_in_department.where(snapshot_time: from.weeks.ago..Time.zone.now)
      else
        metrics_in_department
      end
    end

    def metrics_in_department
      CodeClimateProjectMetric
        .joins(project: { language: :department })
        .where(departments: { id: department.id })
    end
  end
end
