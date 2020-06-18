module Metrics
  class Base < BaseService
    def calculate_avg(entities, metric_type)
      entities.reject { |_entity, count| count == 1 }.each do |entity, count|
        Metric.find_by!(ownable: entity, value_timestamp: metric_interval, name: metric_type)
              .tap do |metric|
          metric.value = metric.value / count
          metric.save!
        end
      end
    end

    def create_or_update_metric(entity_id, entity_type, interval, metric_value, metric_type)
      metric = Metric.find_or_initialize_by(ownable_id: entity_id,
                                            ownable_type: entity_type,
                                            value_timestamp: interval,
                                            name: metric_type)
      return metric.update!(value: (metric_value + metric.value)) if metric.persisted?

      metric.value = metric_value
      metric.save!
    end

    def find_user_project(user, project)
      user.users_projects.detect { |user_project| user_project.project_id == project.id }
    end
  end
end
