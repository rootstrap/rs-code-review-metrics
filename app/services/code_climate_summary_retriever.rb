class CodeClimateSummaryRetriever < BaseService
  attr_reader :project_id

  def initialize(project_id)
    @project_id = project_id
  end

  def call
    CodeClimateProjectMetric.joins(:project).find_by(projects: { id: project_id })
  end
end
