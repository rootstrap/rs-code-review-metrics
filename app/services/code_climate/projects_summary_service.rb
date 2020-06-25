module CodeClimate
  class ProjectsSummaryService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies: [])
      @department = department
      @from = from
      @technologies = technologies
    end

    def call
      build_summary
    end

    private

    def build_summary
      return ProjectsSummary.new unless metrics?

      ProjectsSummary.new(
        invalid_issues_count_average: invalid_issues_count_average,
        wontfix_issues_count_average: wont_fix_issues_count_average,
        open_issues_count_average: open_issues_count_average,
        ratings: ratings
      )
    end

    def metrics?
      !code_climate_metrics.empty?
    end

    def invalid_issues_count_average
      code_climate_metrics.map(&:invalid_issues_count).sum / code_climate_metrics.size
    end

    def wont_fix_issues_count_average
      code_climate_metrics.map(&:wont_fix_issues_count).sum / code_climate_metrics.size
    end

    def open_issues_count_average
      code_climate_metrics.map(&:open_issues_count).sum / code_climate_metrics.size
    end

    def ratings
      code_climate_metrics.each_with_object(Hash.new(0)) do |code_climate_metrics, ratings|
        ratings[code_climate_metrics.code_climate_rate] += 1
      end
    end

    def code_climate_metrics
      @code_climate_metrics ||= metrics_in_given_technologies
    end

    def metrics_in_given_technologies
      if technologies.empty?
        metrics_in_time_period
      else
        metrics_in_time_period.where('projects.lang IN (?)', technologies)
      end
    end

    def metrics_in_time_period
      if from
        metrics_in_department.where('snapshot_time >= ?', from)
      else
        metrics_in_department
      end
    end

    def metrics_in_department
      CodeClimateProjectMetric
        .joins(:project)
        .where(projects: { department_id: department.id })
    end
  end
end
