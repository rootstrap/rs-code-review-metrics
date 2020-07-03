module Builders
  module Chartkick
    class DepartmentDistributionData < Builders::Chartkick::Base
      def call
        department_name = ::Department.find(@entity_id).name

        review_turnarounds = retrieve_review_turnarounds
        [{ name: department_name, data: build_distribution_data(review_turnarounds) }]
      end

      private

      def retrieve_review_turnarounds
        ReviewTurnaround.joins(review_request: { project: { language: :department } })
                        .where(departments: { id: @entity_id })
                        .where(created_at: @query[:value_timestamp])
      end
    end
  end
end
