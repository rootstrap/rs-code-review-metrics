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

  def stub_get_repos_from_user(username, payload = {})
    stub_request(:get, "https://api.github.com/users/#{username}/repos?type=member")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_pull_requests(github_id, payload = {})
    stub_request(:get, "https://api.github.com/repositories/#{github_id}/pulls")
      .to_return(
        body: JSON.generate(payload),
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
    stub_auth_envs

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

  # The results_per_page attribute is meant just for testing purposes
  # The API will be stubbed anyway with the amount used in GithubClient::Organization#repositories
  def stub_organization_repositories(
    repository_payloads,
    results_per_page: GithubClient::Organization::MAX_REPOSITORIES_PER_PAGE
  )
    stub_auth_envs

    url = 'https://api.github.com/orgs/rootstrap/repos'
    groups_of_repositories = repository_payloads.in_groups_of(results_per_page, false)

    groups_of_repositories.push([]).each.with_index do |repositories, index|
      stub_request(:get, url)
        .with(
          basic_auth: [github_admin_user, github_admin_token],
          query: {
            page: index + 1,
            per_page: GithubClient::Organization::MAX_REPOSITORIES_PER_PAGE
          }
        )
        .to_return(body: JSON.generate(repositories), status: 200)
    end
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

  def stub_auth_envs
    stub_env('GITHUB_ADMIN_USER', github_admin_user)
    stub_env('GITHUB_ADMIN_TOKEN', github_admin_token)
  end
end
