module Builders
  module Chartkick
    class ProjectDistributionData < Builders::Chartkick::Base
      def call
        project_name = ::Project.find(@entity_id).name

        [{ name: project_name, data: build_distribution_data(retrieve_records) }]
      end

      private

      def retrieve_records
        merge_times
      end

      def merge_times
        ::MergeTime.joins(pull_request: :project)
                   .where(projects: { id: @entity_id })
                   .where(created_at: @query[:value_timestamp])
      end
    end
  end
end
