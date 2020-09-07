module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        [{ name: department_name, data: build_distribution_data(retrieve_records) }]
      end

      private

      def retrieve_records
        metric
          .records_with_departments
          .where(departments: { id: @entity_id })
          .where(created_at: @query[:value_timestamp])
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
        def records_with_departments
          ::MergeTime.joins(pull_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end

      class ReviewTurnaround
        def records_with_departments
          ::CompletedReviewTurnaround.joins(review_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end

      class PullRequestSize
        def records_with_departments
          ::PullRequestSize.joins(pull_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PRSize.call(entity.value)
        end
      end
    end
  end
end
