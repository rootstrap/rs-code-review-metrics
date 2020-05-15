class ChartkickDataBuilder < BaseService
  SECONDS = 3600

  def initialize(entity:, query:)
    @entity = entity
    @query = query
  end

  def call
    @entity.map do |per_entity|
      metrics = per_entity.metrics.where(@query)
      { name: per_entity.name, data: build_data(metrics) }
    end
  end

  private

  def build_data(metrics)
    metrics.each.inject({}) do |hash, metric|
      hash.merge!(
        metric.value_timestamp.strftime('%Y-%m-%d').to_s => value_in_hours_for(metric)
      )
    end
  end

  def value_in_hours_for(metric)
    (metric.value.to_f / SECONDS).round(2)
  end
end
