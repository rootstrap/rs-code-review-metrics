module Queries
  class DailyMetrics < BaseService
    FROM = 14.days

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      users_project.map do |uspr|
        metrics = uspr.metrics.where(created_at: (actual_time - FROM)..actual_time)
        { name: uspr.user.login, data: format_data(metrics) }
      end
    end

    private

    def users_project
      @users_project ||= Project.find(@project_id).users_projects
    end

    def format_data(metrics)
      metrics.each.inject({}) do |hash, metric|
        hash.merge!(metric.created_at.strftime('%Y-%m-%d').to_s =>  metric.value.to_i / 60)
      end
    end

    def actual_time
      @actual_time ||= Time.zone.now
    end
  end
end
