module Queries
  class DailyMetrics < BaseService
    FROM = 14.days

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      ChartkickDataBuilder.call(
        entity: users_project,
        query: query
      )
    end

    private

    def query
      {
        value_timestamp: (actual_time - FROM)..actual_time,
        interval: :daily
      }
    end

    def users_project
      @users_project ||= UsersProject.where(project_id: @project_id)
    end

    def actual_time
      @actual_time ||= Time.zone.now
    end
  end
end
