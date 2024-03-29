class RepositoryMetricPresenter
  METRIC_FILTERS = %i[per_repository per_users_repository per_repository_distribution].freeze
  METRIC_FILTERS.each do |filter|
    define_method("#{filter}_has_data_to_display?") do
      content = metric.dig(filter, 0, :data)
      content.present?
    end
  end

  attr_reader :metric, :metric_name, :metric_explanation

  def initialize(metric_hash, metric_definition)
    @metric_name = metric_definition.name
    @metric_explanation = metric_definition.explanation
    @metric = metric_hash
  end
end
