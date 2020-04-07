module Metrics
  module ReviewTurnaround
    class PerProject < Processors::Metric
      private

      def process
        review_turnaround_average.each do |project_id:, turnaround_as_seconds:|
          save_value(project_id: project_id, turnaround_as_seconds: turnaround_as_seconds)
        end

        update_last_process_time
      end

      def review_turnaround_average
        @review_turnaround_average ||=
          Queries::ReviewsTurnaroundPerProjectQuery.new(time_interval: time_interval)
      end

      def save_value(project_id:, turnaround_as_seconds:)
        update_metric(
          entity_key: project_id,
          entity_type: Project.to_s,
          value: turnaround_as_seconds,
          value_timestamp: time_interval.starting_at
        )
      end

      def update_last_process_time
        last_processed_review = review_turnaround_average.last_processed_review
        return unless last_processed_review

        metrics_definition.update!(
          last_processed_event_time: last_processed_review.created_at
        )
      end
    end
  end
end
