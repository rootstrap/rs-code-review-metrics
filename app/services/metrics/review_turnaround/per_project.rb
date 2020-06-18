module Metrics
  module ReviewTurnaround
    class PerProject < Metrics::Base
      def initialize(interval = nil)
        @interval = interval
      end

      def call
        process
      end

      private

      def process
        retrieve_projects_and_review_count.each do |project_id, reviews_count|
          turnaround = calculate_turnaround(project_id, reviews_count)
          create_or_update_metric(project_id, Project.to_s, metric_interval,
                                  turnaround, :review_turnaround)
        end
      end

      def filtered_reviews_ids
        @filtered_reviews_ids ||=
          Events::Review.joins(:review_request)
                        .where(opened_at: metric_interval)
                        .order(:pull_request_id, :owner_id, :project_id, :opened_at)
                        .pluck(Arel.sql('DISTINCT ON (reviews.pull_request_id,'\
                                        'reviews.owner_id, reviews.project_id) reviews.project_id,'\
                                        'reviews.opened_at, review_requests.created_at'))
      end

      def retrieve_projects_and_review_count
        filtered_reviews_ids.each_with_object(Hash.new(0)) do |arr, hash|
          hash[arr.first] += 1
          hash
        end
      end

      def calculate_turnaround(project_id, reviews_count)
        filtered_reviews_ids
          .select { |arr| arr.first == project_id }
          .inject(0) { |sum, (_project_id, opened_at, created_at)|
            sum + (opened_at.to_i - created_at.to_i)
          }./(reviews_count)
      end

      def metric_interval
        @metric_interval ||= @interval || Time.zone.today.all_day
      end
    end
  end
end
