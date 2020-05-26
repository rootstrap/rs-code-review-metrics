module Queries
  class BaseQueryMetric < BaseService
    def call
      ChartkickDataBuilder.call(
        entity: users_project,
        query: query
      )
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
  end
end
