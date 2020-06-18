module CodeClimate
  class ProjectsSummaryService < BaseService
    attr_reader :departments, :from, :technologies

    def initialize(departments:, from:, technologies:)
      @departments = departments
      @from = from
      @technologies = technologies
    end

    def call
      build_summary
    end

    private

    def build_summary
      code_climate_information = query_code_climate_information

      ProjectsSummary.new(
        invalid_issues_count_average: code_climate_information[:invalid_issues_count_average],
        wontfix_issues_count_average: code_climate_information[:wontfix_issues_count_average],
        open_issues_count_average: code_climate_information[:open_issues_count_average],
        ratings: code_climate_information[:ratings]
      )
    end

    def query_code_climate_information
      {
        invalid_issues_count_average: 1,
        wontfix_issues_count_average: 2,
        open_issues_count_average: 3,
        ratings: {
          'A' => 1,
          'Z' => 1
        }
      }
    end
  end
end
