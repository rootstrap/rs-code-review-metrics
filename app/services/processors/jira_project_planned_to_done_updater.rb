module Processors
  class JiraProjectPlannedToDoneUpdater < BaseService
    ACTIVE = 'active'.freeze

    def initialize(jira_board)
      @jira_board = jira_board
    end

    def call
      sprints_to_update.each do |sprint|
        sprint.deep_symbolize_keys!
        jira_sprint = JiraSprint.find_or_initialize_by(
          jira_id: sprint[:id],
          jira_board_id: @jira_board.id
        )
        sprint_update!(jira_sprint, sprint)
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

    def sprints_to_update
      JiraClient::Repository.new(@jira_board).sprints
    end

    def sprint_update!(jira_sprint, sprint)
      sprint_report = sprint[:report]
      completed = sprint_report[:completedIssuesEstimateSum][:value] || 0
      jira_sprint.update!(
        name: sprint[:name],
        points_committed: completed + (sprint_report[:issuesNotCompletedEstimateSum][:value] || 0),
        points_completed: completed,
        started_at: sprint[:startDate],
        ended_at: sprint[:endDate],
        active: sprint[:state] == ACTIVE
      )
    end
  end
end
