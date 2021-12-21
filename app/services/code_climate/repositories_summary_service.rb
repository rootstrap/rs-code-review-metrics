module CodeClimate
  class RepositoriesSummaryService < BaseService
    attr_reader :department, :from, :to, :technologies

    def initialize(department:, from:, to:, technologies: [])
      @department = department
      @from = from
      @to = to
      @technologies = technologies
    end

    def call
      return RepositoriesSummary.new unless metrics?

      RepositoriesSummary.new(
        invalid_issues_count_average: invalid_issues_count_average.round(2),
        wont_fix_issues_count_average: wont_fix_issues_count_average.round(2),
        open_issues_count_average: open_issues_count_average.round(2),
        test_coverage_average: test_coverage_average&.round,
        ratings: ratings,
        repositories_without_cc_count: repositories_without_cc_count
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

    def test_coverage_average
      code_climate_metrics.average(:test_coverage)
    end

    def ratings
      code_climate_ratings.each_with_object(Hash.new(0)) do |code_climate_metric, ratings|
        letter = code_climate_metric[1]
        ratings[letter] += 1 if letter.present?
      end
    end

    def code_climate_ratings
      @code_climate_ratings ||= sort_ratings_by_date(
        code_climate_metrics.pluck(:id,
                                   :code_climate_rate,
                                   'code_climate_repository_metrics.created_at')
      )
    end

    def sort_ratings_by_date(cc_metrics)
      cc_metrics.sort_by { |id_rate_date| [id_rate_date[0], id_rate_date[2]] }
                .each_with_object({}) { |id_rate, hsh| hsh[id_rate[0]] = id_rate[1] }
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
        metrics_in_department.with_activity_by_dates(from, to)
        byebug
    end

    def metrics_in_department
      Repository.joins(:code_climate_repository_metric, :language)
                .where(language: department.languages)
                .distinct
                .relevant
    end

    def repositories_without_cc_count
      (ids_without_rate - ids_with_rate).count
    end

    def ids_without_rate
      repositories_without_cc = Repository.without_cc_or_cc_rate
                                          .joins(:language)
                                          .where(language: department.languages)
                                          .distinct
                                          .relevant

      repositories_without_cc = repositories_without_cc.with_activity_by_dates(from, to)

      repositories_without_cc.pluck(:id)
    end

    def ids_with_rate
      code_climate_ratings.map { |id_rate| id_rate[0] if id_rate[1].present? }.compact
    end
  end
end
