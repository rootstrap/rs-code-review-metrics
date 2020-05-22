module Queries
  class DailyMetrics < BaseQueryMetric
    FROM = 14.days
    INTERVAL = 'daily'.freeze

    def initialize(project_id:, metric_name:)
      @project_id = project_id
      @metric_name = metric_name
    end

    private

    def interval
      INTERVAL
    end

    def value_timestamp
      FROM.ago(current_time)..current_time
    end

    def users_project
      @users_project ||= UsersProject.where(project_id: @project_id)
    end
  end
end
