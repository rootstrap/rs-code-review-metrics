module Metrics
  class ReviewTurnaroundPerUserProcessor < MetricProcessor
    private

    def process
      review_turnaround_average.each do |review_turnaround|
        find_or_create_metric(entity: review_turnaround[:user_id])
          .update!(value: review_turnaround[:turnaround],
                   value_timestamp: time_interval.starting_at)
      end
    end

    def review_turnaround_average
      Queries::ReviewsTurnaroundPerUserQuery.call(time_interval: time_interval)
    end
  end
end
