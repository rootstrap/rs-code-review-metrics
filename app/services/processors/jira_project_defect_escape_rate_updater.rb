module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    IN_PROGRESS = 'In Progress'.freeze
    TO_DO = 'To Do'.freeze
    STATUS = 'status'.freeze
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD'].to_sym

    def initialize(jira_board)
      @jira_board = jira_board
    end

    def call
      bugs_to_update.each do |bug|
        bug.deep_symbolize_keys!
        bug_fields = bug[:fields]

        changelog = bug[:changelog]
        histories = changelog[:histories] if changelog.present?

        issue = JiraIssue.find_or_initialize_by(
          key: bug[:key],
          jira_board_id: @jira_board.id
        )

        issue_update!(issue, bug_fields, histories)
      end
    end

    private

    def bugs_to_update
      JiraClient::Repository.new(@jira_board).bugs
    end

    def issue_update!(issue, bug_fields, histories)
      environment_field = parse_by_envirorment(bug_fields[JIRA_ENVIRONMENT_FIELD])

      issue.update!(
        informed_at: bug_fields[:created],
        resolved_at: bug_fields[:resolutiondate] || nil,
        in_progress_at: in_progress_at(histories) || issue.in_progress_at,
        environment: environment_field,
        issue_type: 'bug'
      )
    end

    def parse_by_envirorment(environment)
      regex = /(qa{1})(\s[-]){1}/
      env_field = environment ? environment.first[:value].downcase : nil

      return env_field unless env_field.present? && env_field.match?(regex)

      env_field.split(' ').first
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
  end
end
