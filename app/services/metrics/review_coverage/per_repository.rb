module Metrics
  module ReviewCoverage
    class PerRepository < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |repository_id, metric_value|
            Metric.new(repository_id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        Repository.joins(pull_requests: :review_requests)
                  .where(events_pull_requests: { merged_at: interval })
                  .where(id: @entity_id)
                  .group(:id)
                  .pluck(:id, Arel.sql('AVG(review_coverages.coverage_percentage)'))
      end
    end
  end
end
