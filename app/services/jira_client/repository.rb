module JiraClient
  class Repository < JiraClient::Base
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD']

    def initialize(jira_board)
      @jira_board = jira_board
    end

    def board
      return if @jira_board.jira_board_id.present?

      JSON.parse(fetch_board_response.body)['values'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      raised_exception(exception)
    end

    def bugs
      create_request('issuetype=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      raised_exception(exception)
    end

    def issues
      create_request('issuetype!=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      raised_exception(exception)
    end

    def sprints
      @sprints = JSON.parse(fetch_sprint_response.body)['values'].map(&:deep_symbolize_keys)
      @sprints.each do |sprint|
        sprint_report = JSON.parse(fetch_report_response(sprint[:id]).body)['contents']
        sprint.merge!(report: sprint_report)
      end
      @sprints
    rescue Faraday::ForbiddenError => exception
      raised_exception(exception)
    end

    private

    def create_request(issue_type)
      @request_params = {
        jql: "project='#{@jira_board.jira_project_key}' AND #{issue_type}",
        fields: "#{JIRA_ENVIRONMENT_FIELD},created,resolutiondate,issuetype",
        expand: 'changelog'
      }
    end

    def fetch_board_response
      agile_connection.get('board') do |request|
        request.params['projectKeyOrId'] = @jira_board.jira_project_key
      end
    end

    def fetch_response
      root_connection.get('search') do |request|
        request.params = @request_params
      end
    end

    def fetch_sprint_response
      agile_connection.get("board/#{@jira_board.jira_board_id}/sprint") do |request|
        request.params['state'] = 'active,closed'
      end
    end

    def fetch_report_response(sprint_id)
      reports_connection.get('rapid/charts/sprintreport') do |request|
        request.params = { rapidViewId: @jira_board.jira_board_id,
                           sprintId: sprint_id }
      end
    end

    def raised_exception(exception)
      ExceptionHunter.track(JiraBoards::NoProjectKeyError.new(@jira_board.jira_project_key),
                            custom_data: exception)
    end
  end
end
