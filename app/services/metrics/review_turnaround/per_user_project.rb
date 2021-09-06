module Metrics
  module ReviewTurnaround
    class PerUserProject < Metrics::Base
      private

      def process
        week_intervals.flat_map do |week|
          interval = build_interval(week)
          query(interval).map do |repository_id, owner_id, metric_value|
            entity = find_user_repository(owner_id, repository_id)
            Metric.new(entity.id, interval.first, metric_value)
          end
        end
      end

      def query(interval)
        ::CompletedReviewTurnaround.joins(:review_request)
                                   .where(created_at: interval)
                                   .where(review_requests: { owner_id: @entity_id })
                                   .group(:repository_id, :owner_id)
                                   .pluck(:repository_id,
                                          :owner_id,
                                          Arel.sql('AVG(completed_review_turnarounds.value)'))
      end
    end
  end
end
