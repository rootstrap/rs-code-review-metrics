module JiraClient
  class Repository < JiraClient::Base
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD']

    def initialize(jira_project)
      @jira_project = jira_project
    end

    def board
      return if @jira_project.jira_board_id.present?

      JSON.parse(fetch_board_response.body)['values'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    def bugs
      create_request('issuetype=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    def issues
      create_request('issuetype!=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    def sprints
      @sprints = JSON.parse(fetch_sprint_response.body)['values'].map(&:deep_symbolize_keys)
      @sprints.each do |sprint|
        sprint_report = JSON.parse(fetch_report_response(sprint[:id]).body)['contents']
        sprint.merge!(report: sprint_report)
      end
      @sprints
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    private

    def create_request(issue_type)
      @request_params = {
        jql: "project=#{@jira_project.jira_project_key} AND #{issue_type}",
        fields: "#{JIRA_ENVIRONMENT_FIELD},created"
      }
    end

    def fetch_board_response
      agile_connection.get('board') do |request|
        request.params['projectKeyOrId'] = @jira_project.jira_project_key
      end
    end

    def fetch_response
      root_connection.get('search') do |request|
        request.params = @request_params
      end
    end

    def fetch_sprint_response
      agile_connection.get("board/#{@jira_project.jira_board_id}/sprint")
    end

    def fetch_report_response(sprint_id)
      reports_connection.get('rapid/charts/sprintreport') do |request|
        request.params = { rapidViewId: @jira_project.jira_board_id,
                           sprintId: sprint_id }
      end
    end
  end
end
