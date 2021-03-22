module JiraApiMock
  def stub_get_bugs_ok(payload, jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}/jira/rest/api/2/search?jql=\
                        project=#{jira_project_key}%20AND%20\
                        issuetype=Bug&\
                        fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_failed_authentication(jira_project_key)
    stub_envs

    stub_request(:get, "#{ENV['JIRA_ROOT_URL']}/jira/rest/api/2/search?jql=\
                        project=#{jira_project_key}%20AND%20\
                        issuetype=Bug&\
                        fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created")
      .to_raise(Faraday::ForbiddenError, 'Unauthorized user')
  end

  def stub_envs
    stub_env('JIRA_ADMIN_USER', jira_admin_user)
    stub_env('JIRA_ADMIN_PASSWORD', jira_admin_password)
    stub_env('JIRA_ENVIRONMENT_FIELD', jira_environment_field)
    stub_env('JIRA_ROOT_URL', jira_root_url)
  end

  private

  def jira_admin_user
    'adminuser'
  end

  def jira_admin_password
    'asdminpassword'
  end

  def jira_environment_field
    'customfield'
  end

  def jira_root_url
    'http://localhost:2990'
  end
end
