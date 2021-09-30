module EnvMock
  def stub_envs
    stub_env('JIRA_ADMIN_USER', jira_admin_user)
    stub_env('JIRA_ADMIN_TOKEN', jira_admin_token)
    stub_env('JIRA_ENVIRONMENT_FIELD', jira_environment_field)
    stub_env('JIRA_ROOT_URL', jira_root_url)
    stub_env('JIRA_AGILE_URL', jira_agile_url)
    stub_env('JIRA_REPORTS_URL', jira_reports_url)
    stub_env('QUICKCHART_URL', quickchart_url)
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

  def quickchart_url
    'https://quickchart.io/chart/create'
  end
end
