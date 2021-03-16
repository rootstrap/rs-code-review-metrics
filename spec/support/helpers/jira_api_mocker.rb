module JiraApiMock
  def stub_get_bugs_ok(payload)
    stub_envs

    stub_request(:get, "http://localhost:2990/jira/rest/api/2/search?jql=issueType=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,project")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_failed_authentication
    stub_envs

    stub_request(:get, "http://localhost:2990/jira/rest/api/2/search?jql=issueType=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,project")
      .to_raise(Faraday::ForbiddenError, 'Unauthorized user')
  end

  def stub_envs
    stub_env('JIRA_ADMIN_USER', jira_admin_user)
    stub_env('JIRA_ADMIN_PASSWORD', jira_admin_password)
    stub_env('JIRA_ENVIRONMENT_FIELD', jira_environment_field)
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
end
