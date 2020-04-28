module Queries
  class DailyMetrics < BaseService
    FROM = 14.days

    def initialize(project_id)
      @project_id = project_id
    end

    def call
      users_project.map do |uspr|
        metrics = uspr.metrics.where(created_at: (Time.zone.now - FROM)..Time.zone.now)
        { name: uspr.user.login, data: format_data(metrics) }
      end
    end

    def users_project
      @users_project ||= Project.find(@project_id).users_projects
    end

    def format_data(metrics)
      dates_and_values = Hash.new
      metrics.each do |metric|
        dates_and_values.merge!(
          "#{metric.created_at.strftime( "%Y-%m-%d" )}" => metric.value.to_i / 60
        )
      end
      dates_and_values
    end
  end
end
