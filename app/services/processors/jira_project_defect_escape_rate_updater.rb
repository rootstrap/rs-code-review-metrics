module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    IN_PROGRESS = 'In Progress'.freeze
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD'].to_sym

    def initialize(product)
      @product = product
    end

    def call
      bugs_to_update.each do |bug|
        bug.deep_symbolize_keys!
        bug_fields = bug[:fields]

        issue = JiraIssue.find_or_initialize_by(
          key: bug[:key],
          product_id: @product.id
        )

        issue_update!(issue, bug_fields)
      end
    end

    private

    def bugs_to_update
      JiraClient::Repository.new(@product).bugs
    end

    def issue_update!(issue, bug_fields)
      environment_field = bug_fields[JIRA_ENVIRONMENT_FIELD]
      status_field = bug_fields[:status][:name]

      issue.update!(
        informed_at: bug_fields[:created],
        resolved_at: bug_fields[:resolutiondate] || nil,
        in_progress_at: status_field == IN_PROGRESS ? bug_fields[:updated] : issue.in_progress_at,
        environment: environment_field ? environment_field.first[:value].downcase : nil,
        issue_type: 'bug'
      )
    end
  end
end
