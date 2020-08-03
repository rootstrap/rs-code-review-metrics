module CodeClimate
  class ProjectsSummaryService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies: [])
      @department = department
      @from = from.to_i
      @technologies = technologies
    end

    def call
      return ProjectsSummary.new unless metrics?

      ProjectsSummary.new(
        invalid_issues_count_average: invalid_issues_count_average,
        wont_fix_issues_count_average: wont_fix_issues_count_average,
        open_issues_count_average: open_issues_count_average,
        ratings: ratings
      )
    end

    private

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
        metrics_in_time_period.where('languages.name IN (?)', technologies)
      end
    end

    def metrics_in_time_period
      if from.positive?
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
