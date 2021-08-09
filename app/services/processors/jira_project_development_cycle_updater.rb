module Processors
  class JiraProjectDevelopmentCycleUpdater < BaseService
    IN_PROGRESS = 'In Progress'.freeze
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD'].to_sym

    def initialize(product)
      @product = product
    end

    def call
      issues_to_update.each do |issue|
        issue.deep_symbolize_keys!
        issue_fields = issue[:fields]

        issue = JiraIssue.find_or_initialize_by(
          key: issue[:key],
          product_id: @product.id
        )

        issue_update!(issue, issue_fields)
      end
    end

    private

    def issues_to_update
      JiraClient::Repository.new(@product).issues
    end

    def issue_update!(issue, issue_fields)
      environment_field = issue_fields[JIRA_ENVIRONMENT_FIELD]
      status_field = issue_fields[:status][:name]

      issue.update!(
        informed_at: issue_fields[:created],
        resolved_at: issue_fields[:resolutiondate] || nil,
        in_progress_at: status_field == IN_PROGRESS ? issue_fields[:updated] : issue.in_progress_at,
        environment: environment_field ? environment_field.first[:value]&.downcase : nil,
        issue_type: issue_type_field(issue_fields)&.downcase
      )
    end

    def issue_type_field(issue_fields)
      issue_fields[:issuetype][:name]
    end
  end
end
