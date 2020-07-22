module GithubApiMock
  def stub_get_content_from_file_not_found
    stub_request(:get, "#{GithubRepositoryClient::URL}/rs-code-metrics/contents/CODEOWNERS")
      .to_return(body: not_found_body_from_github, status: 404)
  end

  def stub_get_content_from_file_ok(custom_content_file = '')
    stub_request(:get, "#{GithubRepositoryClient::URL}/rs-code-metrics/contents/CODEOWNERS")
      .to_return(
        body: custom_content_file.presence || base_content_file,
        status: 200
      )
  end

  def stub_repository_views(project_name, repository_views_payload)
    stub_env('GITHUB_ADMIN_USER', github_admin_user)
    stub_env('GITHUB_ADMIN_TOKEN', github_admin_token)

    url = "#{GithubRepositoryClient::URL}/#{project_name}/traffic/views"

    stub_request(:get, url)
      .with(basic_auth: [github_admin_user, github_admin_token], query: { per: 'week' })
      .to_return(body: JSON.generate(repository_views_payload), status: 200)
  end

  def not_found_body_from_github
    {
      'message': 'Not Found',
      'documentation_url': 'https://developer.github.com/v3/repos/contents/#get-contents'
    }.to_json
  end

  private

  def base_content_file
    file_fixture('code_owners_file.txt').read
  end

  def github_admin_user
    'adminuser'
  end

  def github_admin_token
    '1q2w3e4r5t'
  end
end
