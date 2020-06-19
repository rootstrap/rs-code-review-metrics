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
      ProjectsSummary.new(
        invalid_issues_count_average: invalid_issues_count_average,
        wontfix_issues_count_average: wont_fix_issues_count_average,
        open_issues_count_average: open_issues_count_average,
        ratings: ratings
      )
    end

    def invalid_issues_count_average
      return if code_climate_metrics.empty?

      code_climate_metrics.map(&:invalid_issues_count).sum / code_climate_metrics.size
    end

    def wont_fix_issues_count_average
      return if code_climate_metrics.empty?

      code_climate_metrics.map(&:wont_fix_issues_count).sum / code_climate_metrics.size
    end

    def open_issues_count_average
      return if code_climate_metrics.empty?

      code_climate_metrics.map(&:open_issues_count).sum / code_climate_metrics.size
    end

    def ratings
      return if code_climate_metrics.empty?

      hash = Hash.new { |h, rate| h[rate] = 0 }
      code_climate_metrics.each_with_object(hash) do |cc, ratings|
        ratings[cc.code_climate_rate] += 1
      end
    end

    def code_climate_metrics
      return [] if department != 'web'

      @code_climate_metrics ||=
        technologies.empty? ? metrics_in_any_technology : metrics_in_given_technologies
    end

    def metrics_in_given_technologies
      CodeClimateProjectMetric
        .joins(:project)
        .where('snapshot_time >= ? AND projects.lang IN (?)', from, technologies)
    end

    def metrics_in_any_technology
      CodeClimateProjectMetric
        .joins(:project)
        .where('snapshot_time >= ?', from)
    end
  end
end
