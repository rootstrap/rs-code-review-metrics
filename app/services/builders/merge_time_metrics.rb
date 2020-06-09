module Builders
  class MergeTimeMetrics < BaseService
    def initialize(project_id, period_metric_query)
      @project_id = project_id
      @period_metric_query = period_metric_query
    end

    def call
      build
    end

    private

    def build
      {
        per_users_project: @period_metric_query.call(
          entity_name: 'users_project', entity_id: @project_id, metric_name: 'merge_time'
        ),
        per_project: @period_metric_query.call(
          entity_name: 'project', entity_id: @project_id, metric_name: 'merge_time'
        )
      }
    end
  end
end
