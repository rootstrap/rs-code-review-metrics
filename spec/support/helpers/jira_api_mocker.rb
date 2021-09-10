module JiraApiMock
  def stub_get_bugs_ok(payload, jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}search?jql=project=#{jira_project_key}%20AND%20issuetype=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,resolutiondate,issuetype&expand=changelog")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_issues_ok(payload, jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}search?jql=project=#{jira_project_key}%20AND%20issuetype!=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,resolutiondate,issuetype&expand=changelog")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_board_ok(payload, jira_project_key)
    stub_envs

    params = { projectKeyOrId: jira_project_key }

    stub_request(:get, "#{ENV['JIRA_AGILE_URL']}board")
      .with(query: params)
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_sprints_ok(payload, jira_board_id)
    stub_envs

    params = { state: 'active,closed' }

    stub_request(:get, "#{ENV['JIRA_AGILE_URL']}board/#{jira_board_id}/sprint")
      .with(query: params)
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_sprint_report_ok(payload, jira_board_id, jira_sprint_id)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_REPORTS_URL']}rapid/charts/sprintreport?rapidViewId=#{jira_board_id}&sprintId=#{jira_sprint_id}")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_failed_authentication(jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}search?jql=project=#{jira_project_key}%20AND%20issuetype=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,resolutiondate,issuetype&expand=changelog")
      .to_raise(Faraday::ForbiddenError, 'Unauthorized user')
  end

  def stub_issues_failed_authentication(jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}search?jql=project=#{jira_project_key}%20AND%20issuetype!=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,resolutiondate,issuetype&expand=changelog")
      .to_raise(Faraday::ForbiddenError, 'Unauthorized user')
  end
end
