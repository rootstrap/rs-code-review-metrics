module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        [{ name: department_name, data: build_distribution_data(retrieve_records) }]
      end

      private

      def retrieve_records
        metric.retrieve_records(
          department_id: @entity_id,
          timestamp_interval: @query[:value_timestamp]
        )
      end

      def metric_name
        @query[:name]
      end

      def metric
        @metric ||= self.class.const_get(metric_name.to_s.camelize).new
      end

      def resolve_interval(entity)
        metric.resolve_interval(entity)
      end

      class MergeTime
        def retrieve_records(department_id:, timestamp_interval:)
          ::MergeTime
            .joins(pull_request: { project: { language: :department } })
            .where(departments: { id: department_id })
            .where(created_at: timestamp_interval)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end

      class ReviewTurnaround
        def retrieve_records(department_id:, timestamp_interval:)
          ::CompletedReviewTurnaround
            .joins(review_request: { project: { language: :department } })
            .where(departments: { id: department_id })
            .where(created_at: timestamp_interval)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end

      class PullRequestSize
        def retrieve_records(department_id:, timestamp_interval:)
          ::PullRequestSize
            .joins(pull_request: { project: { language: :department } })
            .where(departments: { id: department_id })
            .where(created_at: timestamp_interval)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PRSize.call(entity.value)
        end
      end
    end
  end
end
