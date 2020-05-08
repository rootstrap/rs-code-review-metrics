class BaseMetricService < BaseService
  def calculate_avg(entities, metric_type)
    entities.reject { |_entity, count| count == 1 }.each do |entity, count|
      Metric.find_by!(ownable: entity, value_timestamp: metric_interval, name: metric_type)
            .tap do |metric|
        metric.value = metric.value / count
        metric.save!
      end
    end
  end

  def create_or_update_metric(entity, metric_value, metric_type)
    metric = Metric.find_or_initialize_by(ownable: entity,
                                          value_timestamp: Time.zone.today.all_day,
                                          name: metric_type)
    return metric.update!(value: (metric_value + metric.value)) if metric.persisted?

    metric.value = metric_value
    metric.save!
  end
end
