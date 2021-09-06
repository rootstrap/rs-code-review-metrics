class CodeClimateSummaryRetriever < BaseService
  attr_reader :repository_id

  def initialize(repository_id)
    @repository_id = repository_id
  end

  def call
    CodeClimateProjectMetric.joins(:repository).find_by(repositories: { id: repository_id })
  end
end
