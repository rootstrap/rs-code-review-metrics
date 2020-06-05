module Queries
  class CodeClimateSummaryRetriever < BaseService
    attr_reader :project_id

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      CodeClimateProjectMetric.joins(:project).where(projects: { id: project_id }).first
    end
  end
end
