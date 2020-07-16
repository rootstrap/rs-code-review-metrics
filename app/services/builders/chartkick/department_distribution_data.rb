module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        [{ name: department_name, data: build_distribution_data(retrieve_review_turnarounds) }]
      end

      private

      def retrieve_review_turnarounds
        ::ReviewTurnaround.joins(pull_request: { project: { language: :department } })
                          .where(departments: { id: @entity_id })
                          .where(created_at: @query[:value_timestamp])
      end
    end
  end
end
