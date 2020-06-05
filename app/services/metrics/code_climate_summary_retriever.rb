module Queries
  class CodeClimateSummaryRetriever < BaseService
    attr_reader :project_id

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      {
        code_climate_rate: 'A',
        code_climate_invalid_issues_count: 1,
        code_climate_wont_fix_issues_count: 2
      }
    end
  end
end
