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

  def stub_get_pull_requests(github_id, payload = [])
    stub_request(:get, "https://api.github.com/repositories/#{github_id}/pulls")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_pull_requests_events(username, payload = [])
    stub_request(:get, "https://api.github.com/users/#{username}/events/public?page=1")
      .to_return(
        body: JSON.generate(payload),
        status: 200
      )
  end

  def stub_get_pull_request(pull_request, pull_request_payload)
    repo_full_name = pull_request.project.full_name
    pr_number = pull_request.number

    stub_request(:get, "https://api.github.com/repos/#{repo_full_name}/pulls/#{pr_number}")
      .to_return(
        body: JSON.generate(pull_request_payload),
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
    url = 'https://api.github.com/orgs/rootstrap/repos'

    stub_paginated_items(
      repository_payloads,
      url,
      results_per_page,
      GithubClient::Organization::MAX_REPOSITORIES_PER_PAGE
    )
  end

  def stub_organization_members(
    repository_members,
    results_per_page: GithubClient::Organization::MAX_USERS_PER_PAGE
  )
    url = 'https://api.github.com/orgs/rootstrap/members'

    stub_paginated_items(
      repository_members,
      url,
      results_per_page,
      GithubClient::Organization::MAX_USERS_PER_PAGE
    )
  end

  def stub_pull_request_files_with_payload(
    pull_request_payload,
    file_payloads = [create(:pull_request_file_payload)],
    results_per_page: GithubClient::PullRequest::MAX_FILES_PER_PAGE
  )
    project_id = pull_request_payload.dig('repository', 'id')
    pr_number = pull_request_payload.dig('pull_request', 'number')
    stub_pull_request_files(project_id, pr_number, file_payloads, results_per_page)
  end

  def stub_pull_request_files_with_pr(
    pull_request,
    file_payloads = [create(:pull_request_file_payload)],
    results_per_page: GithubClient::PullRequest::MAX_FILES_PER_PAGE
  )
    project_id = pull_request.project.github_id
    pr_number = pull_request.number
    stub_pull_request_files(project_id, pr_number, file_payloads, results_per_page)
  end

  def stub_failed_pull_request_files(pull_request)
    project_id = pull_request.project.github_id
    pr_number = pull_request.number
    url = "https://api.github.com/repositories/#{project_id}/pulls/#{pr_number}/files"

    response_body = {
      'message': 'Not Found',
      'documentation_url': 'https://docs.github.com/rest/reference/pulls#list-pull-requests-files'
    }

    stub_auth_envs

    stub_request(:get, url)
      .with(
        basic_auth: [github_admin_user, github_admin_token],
        query: {
          page: 1,
          per_page: GithubClient::PullRequest::MAX_FILES_PER_PAGE
        }
      )
      .to_return(body: JSON.generate(response_body), status: 404)
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

  # The results_per_page attribute is meant just for testing purposes
  # The API will be stubbed anyway with the amount used in GithubClient::PullRequest#files
  def stub_pull_request_files(project_id, pr_number, file_payloads, results_per_page)
    url = "https://api.github.com/repositories/#{project_id}/pulls/#{pr_number}/files"

    stub_paginated_items(
      file_payloads,
      url,
      results_per_page,
      GithubClient::PullRequest::MAX_FILES_PER_PAGE
    )
  end

  def stub_paginated_items(item_payloads, url, results_per_page, max_results_per_page)
    stub_auth_envs

    groups_of_items = item_payloads.in_groups_of(results_per_page, false)

    groups_of_items.push([]).each.with_index do |items, index|
      stub_request(:get, url)
        .with(
          basic_auth: [github_admin_user, github_admin_token],
          query: {
            page: index + 1,
            per_page: max_results_per_page
          }
        )
        .to_return(body: JSON.generate(items), status: 200)
    end
  end
end
