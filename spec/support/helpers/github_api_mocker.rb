module GithubApiMock
  def stub_get_code_owners_not_found
    stub_request(:get, %r{.*\/repos\/rootstrap.*})
      .to_return(body: not_found_body_from_github, status: 404)
  end

  def stub_get_code_owners_file_ok(custom_content_file = '')
    stub_request(:get, %r{.*\/repos\/rootstrap.*/})
      .to_return(
        body: custom_content_file.presence || base_content_file,
        status: 200
      )
  end

  def stub_successful_repository_views(project, repository_views_payload)
    stub_repository_views(project, repository_views_payload, 200)
  end

  def stub_failed_repository_views(project)
    response_body = {
      'message': 'Not Found',
      'documentation_url': 'https://docs.github.com/rest/reference/repos#get-page-views'
    }
    stub_repository_views(project, response_body, 404)
  end

  def stub_repository_views(project, response_body, status_code)
    stub_env('GITHUB_ADMIN_USER', github_admin_user)
    stub_env('GITHUB_ADMIN_TOKEN', github_admin_token)

    url = "https://api.github.com/repositories/#{project.github_id}/traffic/views"

    stub_request(:get, url)
      .with(basic_auth: [github_admin_user, github_admin_token], query: { per: 'week' })
      .to_return(body: JSON.generate(response_body), status: status_code)
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
