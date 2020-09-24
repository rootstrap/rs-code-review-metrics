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
        invalid_issues_count_average: invalid_issues_count_average.round(2),
        wont_fix_issues_count_average: wont_fix_issues_count_average.round(2),
        open_issues_count_average: open_issues_count_average.round(2),
        ratings: ratings
      )
    end

    private

    def metrics?
      !code_climate_metrics.empty?
    end

    def invalid_issues_count_average
      code_climate_metrics.average(:invalid_issues_count)
    end

    def wont_fix_issues_count_average
      code_climate_metrics.average(:wont_fix_issues_count)
    end

    def open_issues_count_average
      code_climate_metrics.average(:open_issues_count)
    end

    def ratings
      code_climate_ratings = code_climate_metrics.pluck(:code_climate_rate).compact
      code_climate_ratings.each_with_object(Hash.new(0)) do |code_climate_rate, ratings|
        ratings[code_climate_rate] += 1
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
