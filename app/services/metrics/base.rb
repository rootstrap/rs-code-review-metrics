module Metrics
  class Base < BaseService
    Metric = Struct.new(:ownable_id, :ownable_type, :value_timestamp, :name, :value)

    def find_user_project(user_id, project_id)
      user = User.find(user_id)
      user.users_projects.detect { |user_project| user_project.project_id == project_id }
    end

    def split_in_weeks(metric_interval)
      from = metric_interval.first.to_date
      to = metric_interval.last.to_date
      (from..to).group_by(&:cweek)
    end

    def build_interval(week)
      week_last = week.last
      first = week_last.first
      last = week_last.last

      return first.beginning_of_day..first.end_of_day if first == last

      first..last
    end
  end
end
