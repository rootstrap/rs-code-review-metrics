module Queries
  class BaseQueryMetric < BaseService
    INTERVALS = %w[daily weekly].freeze

    def call
      ChartkickDataBuilder.call(
        entity: users_project,
        query: query
      )
    end

    def self.determinate_metric_period(period)
      raise Graph::RangeDateNotSupported unless INTERVALS.include?(period)

      Queries.const_get("#{period.capitalize}Metrics")
    end

    private

    def query
      {
        value_timestamp: value_timestamp,
        interval: interval,
        name: @metric_name
      }
    end

    def current_time
      @current_time ||= Time.zone.now
    end

    def users_project
      UsersProject.where(project_id: @project_id)
    end
  end
end
