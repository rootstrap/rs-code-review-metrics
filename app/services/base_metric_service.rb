class BaseMetricService < BaseService
  def calculate_avg(entities)
    entities.reject { |_entity, count| count == 1 }.each do |entity, count|
      Metric.find_by!(ownable: entity, value_timestamp: metric_interval, name: :merge_time)
            .tap do |metric|
        metric.value = metric.value / count
        metric.save!
      end
    end
  end

  def create_or_update_metric(entity, merge_time)
    metric = Metric.find_or_initialize_by(ownable: entity,
                                          value_timestamp: Time.zone.today.all_day,
                                          name: :merge_time)
    return metric.update!(value: (merge_time + metric.value)) if metric.persisted?

    metric.value = merge_time
    metric.save!
  end
end
