module Metrics
  module MergeTime
    class PerProject < Metrics::Base
      def initialize(interval = nil)
        @interval = interval
      end

      def call
        process
      end

      private

      def process
        filtered_projects.each do |project|
          turnaround = calculate_turnaround(project)
          create_or_update_metric(project.id, Project.to_s, metric_interval,
                                  turnaround, :merge_time)
        end
      end

      def filtered_projects
        Project.includes(:pull_requests).where(pull_requests: { merged_at: metric_interval })
      end

      def pull_requests_count
        @pull_requests_count ||= Project.joins(:pull_requests).group(:id).count('pull_requests.id')
      end

      def calculate_turnaround(project)
        total = project.pull_requests.inject(0) do |sum, pr|
          sum + (pr.merged_at.to_i - pr.opened_at.to_i)
        end
        total / pull_requests_count.fetch(project.id)
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
