module Processors
  class JiraProjectDevelopmentCycleUpdater < BaseService
    IN_PROGRESS = 'In Progress'.freeze
    TO_DO = 'To Do'.freeze
    STATUS = 'status'.freeze
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD'].to_sym

    def initialize(jira_board)
      @jira_board = jira_board
    end

    def call
      issues_to_update.each do |issue|
        issue.deep_symbolize_keys!
        issue_fields = issue[:fields]

        changelog = issue[:changelog]
        histories = changelog[:histories] if changelog.present?

        issue = JiraIssue.find_or_initialize_by(
          key: issue[:key],
          jira_board_id: @jira_board.id
        )

        issue_update!(issue, issue_fields, histories)
      end
    end

    private

    def issues_to_update
      JiraClient::Repository.new(@jira_board).issues
    end

    def issue_update!(issue, issue_fields, histories)
      environment_field = issue_fields[JIRA_ENVIRONMENT_FIELD]

      issue_type = issue_type_field(issue_fields)&.downcase

      return unless handleable_issue?(issue_type)

      issue.update!(
        informed_at: issue_fields[:created],
        resolved_at: issue_fields[:resolutiondate] || nil,
        in_progress_at: in_progress_at(histories) || issue.in_progress_at,
        environment: environment_field ? environment_field.first[:value]&.downcase : nil,
        issue_type: issue_type
      )
    end

    def issue_type_field(issue_fields)
      issue_fields[:issuetype][:name]
    end

    def in_progress_at(histories)
      return unless histories

      in_progress_at = histories.find do |history|
        items = history[:items]&.first

        items && items[:fieldId] == STATUS &&
          items[:fromString] == TO_DO && items[:toString] == IN_PROGRESS
      end

      in_progress_at[:created] if in_progress_at.presence
    end

    def handleable_issue?(issue_type)
      JiraIssue.issue_types.include?(issue_type)
    end
  end
end
