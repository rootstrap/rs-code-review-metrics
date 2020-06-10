module Builders
  class ReviewTurnaroundMetrics < MetricsBase
    def call
      build
    end

    private

    def build
      {
        per_users_project: @period_metric_query.call(
          entity_name: 'users_project', entity_id: @project_id, metric_name: 'review_turnaround'
        ),
        per_project: @period_metric_query.call(
          entity_name: 'project', entity_id: @project_id, metric_name: 'review_turnaround'
        )
      }
    end
  end
end
