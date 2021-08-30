module Metrics
  module MergeTime
    class PerLanguage < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |language_id, metric_value|
            Metric.new(language_id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        Language.joins(projects: { pull_requests: :merge_time })
                .where(events_pull_requests: { merged_at: interval })
                .where(id: @entity_id)
                .group(:id)
                .pluck(:id, Arel.sql('AVG(merge_times.value)'))
      end
    end
  end
end
