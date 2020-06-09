class TechnologyGrowthMomCalculator < BaseService
  def initialize(metric_name, months)
    @metric_name = metric_name
    @months = months
  end

  def call
    Technology.all.map do |technology|
      {
        name: technology.name.titlecase,
        data: growth_mom_for(technology)
      }
    end
  end

  private

  attr_reader :metric_name, :months

  def growth_mom_for(technology)
    metrics = metrics_for(technology)

    metrics.each.with_index.inject({}) do |hash, metric_with_index|
      metric, index = metric_with_index
      previous_metric = metrics[index - 1]
      next(hash) if index.zero? || previous_metric.value.zero?

      hash.merge!(
        metric.value_timestamp.strftime('%B %Y') => growth_for(metric, previous_metric)
      )
    end
  end

  def metrics_for(technology)
    technology.metrics
              .where(name: metric_name)
              .where('value_timestamp > ?', (months + 1).months.ago)
              .order(:value_timestamp)
  end

  def growth_for(metric, previous_metric)
    (metric.value - previous_metric.value) / previous_metric.value * 100
  end
end