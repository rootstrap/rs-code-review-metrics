module CodeClimate
  class ProjectsDetailsService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies: [])
      @department = department
      @from = from.to_i
      @technologies = technologies
    end

    def call
      code_climate_metrics.map do |metric|
        ProjectSummary.new(rate: metric.code_climate_rate,
                           issues: issues_collection(metric),
                           snapshot_time: metric.snapshot_time,
                           test_coverage: metric.test_coverage&.round,
                           name: metric.repository.name)
      end
    end

    private

    def issues_collection(metric)
      {
        invalid_issues_count: metric.invalid_issues_count,
        open_issues_count: metric.open_issues_count,
        wont_fix_issues_count: metric.wont_fix_issues_count
      }
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
      if from.positive?
        metrics_in_department.merge(Repository.with_activity_after(from.weeks.ago))
                             .group('code_climate_project_metrics.id')
                             .group('repositories.id')
      else
        metrics_in_department
      end
    end

    def metrics_in_department
      CodeClimateProjectMetric
        .with_rates
        .joins(repository: { language: :department })
        .where(departments: { id: department.id })
        .order('LOWER(repositories.name)')
    end
  end
end
