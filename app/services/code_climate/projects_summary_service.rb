module CodeClimate
  class ProjectsSummaryService < BaseService
    attr_reader :department, :from, :technologies

    def initialize(department:, from:, technologies:)
      @department = department
      @from = from
      @technologies = technologies
    end

    def call
      build_summary
    end

    private

    def build_summary
      return ProjectsSummary.new if department != 'web'

      ProjectsSummary.new(
        invalid_issues_count_average: invalid_issues_count_average,
        wontfix_issues_count_average: wont_fix_issues_count_average,
        open_issues_count_average: open_issues_count_average,
        ratings: ratings
      )
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
      hash = Hash.new { |hash, rate| hash[rate] = 0 }
      code_climate_metrics.each_with_object(hash) do |cc, ratings|
        ratings[cc.code_climate_rate] += 1
      end
    end

    def code_climate_metrics
      @code_climate_metrics ||= CodeClimateProjectMetric.all
    end
  end
end
