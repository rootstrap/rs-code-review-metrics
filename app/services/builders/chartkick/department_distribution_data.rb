module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        [{ name: department_name, data: build_distribution_data(retrieve_records) }]
      end

      private

      def retrieve_records
        return review_turnarounds if @query[:name].equal?(:review_turnaround)

        merge_times
      end

      def review_turnarounds
        ::ReviewTurnaround.joins(pull_request: { project: { language: :department } })
                          .where(departments: { id: @entity_id })
                          .where(created_at: @query[:value_timestamp])
      end

      def merge_times
        ::MergeTime.joins(pull_request: { project: { language: :department } })
                   .where(departments: { id: @entity_id })
                   .where(created_at: @query[:value_timestamp])
      end
    end
  end
end
