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

    stub_request(:get, "#{ENV['JIRA_AGILE_URL']}board/#{jira_board_id}/sprint")
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

  def stub_envs
    stub_env('JIRA_ADMIN_USER', jira_admin_user)
    stub_env('JIRA_ADMIN_TOKEN', jira_admin_token)
    stub_env('JIRA_ENVIRONMENT_FIELD', jira_environment_field)
    stub_env('JIRA_ROOT_URL', jira_root_url)
    stub_env('JIRA_AGILE_URL', jira_agile_url)
    stub_env('JIRA_REPORTS_URL', jira_reports_url)
  end

  private

  def jira_admin_user
    'adminuser'
  end

  def jira_admin_token
    '123ir123r91238ry123rihb'
  end

  def jira_environment_field
    'customfield_10000'
  end

  def jira_root_url
    'https://name.atlassian.net/rest/api/3/'
  end

  def jira_agile_url
    'https://name.atlassian.net/rest/agile/latest/'
  end

  def jira_reports_url
    'https://name.atlassian.net/rest/greenhopper/latest/'
  end
end
