module Queries
  class WeeklyMetrics < BaseService

    def initialize(project_id, number_of_previous: 3)
      @project_id = project_id
      @number_of_previous = number_of_previous
    end

    def call
      ChartkickDataBuilder.call(
        entity: users_project,
        query: query
      )
    end

    def query
      {
        value_timestamp: weeks_range,
        interval: :weekly
      }
    end

    def weeks_range
      (current_time - @number_of_previous.weeks).beginning_of_week..current_time.end_of_week
    end

    def users_project
      UsersProject.where(project_id: @project_id)
    end

    def current_time
      @current_time ||= Time.zone.now
    end
  end
end
