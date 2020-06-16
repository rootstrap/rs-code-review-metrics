class TechnologyGrowthMomCalculator < BaseService
  def initialize(metric_name, months)
    @metric_name = metric_name
    @months = months
  end

  def call
    formatted_metrics = Technology.all.map do |technology|
      {
        name: technology.name.titlecase,
        data: growth_mom_for(technology.metrics)
      }
    end

    formatted_metrics << totals_hash
  end

  private

  attr_reader :metric_name, :months

  def growth_mom_for(technology_metrics)
    metrics = data_for(technology_metrics)

    metrics.each.with_index.inject({}) do |hash, key_value_pair_with_index|
      key_value_pair, index = key_value_pair_with_index
      month, metric_value = key_value_pair
      previous_metric_value = metrics[month.last_month]
      next(hash) if index.zero? || previous_metric_value.zero?

      hash.merge!(
        month.strftime('%B %Y') => growth_for(metric_value, previous_metric_value)
      )
    end
  end

  def data_for(technology_metrics)
    technology_metrics.where(name: metric_name)
                      .group_by_month(:value_timestamp, last: months + 1)
                      .sum(:value)
  end

  def growth_for(metric_value, previous_metric_value)
    (metric_value - previous_metric_value) / previous_metric_value * 100
  end

  def totals_hash
    {
      name: 'Totals',
      data: growth_mom_for(Metric.where(ownable_type: Technology.to_s))
    }
  end
end
