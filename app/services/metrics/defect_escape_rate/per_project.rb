module Metrics
  module DefectEscapeRate
    class PerProject < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |project_id, metric_value|
            Metric.new(project_id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        project = JiraProject.find_by!(project_id: @entity_id)
        bug_issues = project.jira_issues.bug.where(informed_at: interval)
        return [] if bug_issues.empty?

        defect_rate = bug_issues
                      .where(environment: %w[staging production]).count * 100 / bug_issues.count
        [[
          @entity_id, {
            defect_rate: defect_rate,
            bugs_by_environment: bugs_by_environment(bug_issues)
          }
        ]]
      end

      def bugs_by_environment(bug_issues)
        bug_issues.each_with_object({}) do |bug, result|
          result[bug.environment] = +1
        end
      end
    end
  end
end
