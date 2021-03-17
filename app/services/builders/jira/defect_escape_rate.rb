module Builders
  module Jira
    class DefectEscapeRate < BaseService
      def initialize(jira_project_name:, from:, to:)
        @jira_project_name = jira_project_name
        @from = from
        @to = to
      end

      def call
        bugs_for_range.each_with_object(hash_of_arrays) do |jira_issue, hash|
          environment = jira_issue.environment
          hash[environment] << { key: jira_issue.key, informed_at: jira_issue.informed_at }
        end
      end

      attr_reader :jira_project_name, :from, :to

      private

      def bugs_for_range
        @bugs_for_range ||= JiraIssue.where(informed_at: from..to).bugs.for_project(jira_project_name)
      end

      def hash_of_arrays
        Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
