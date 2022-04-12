module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    IN_PROGRESS = 'In Progress'.freeze
    TO_DO = 'To Do'.freeze
    STATUS = 'status'.freeze

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

    def standar_environment(bug_fields)
      JiraClient::Repository.new(@jira_board).enviroment_fields.each do |field|
        bug_field = bug_fields[field.to_sym]
        custom_environment = bug_field ? bug_field.first[:value].downcase : nil
        environment = @jira_board.jira_environments
                                 .where('LOWER(custom_environment) = ?',
                                        custom_environment).first
        return environment[:environment] unless environment.nil?
      end
      nil
    end

    def bugs_to_update
      JiraClient::Repository.new(@jira_board).bugs
    end

    def issue_update!(issue, bug_fields, histories)
      issue.update!(
        informed_at: bug_fields[:created],
        resolved_at: bug_fields[:resolutiondate] || nil,
        in_progress_at: in_progress_at(histories) || issue.in_progress_at,
        environment: standar_environment(bug_fields),
        issue_type: 'bug'
      )
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
